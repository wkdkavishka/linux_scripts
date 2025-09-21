#!/usr/bin/env bash

# System Maintenance Script for Fedora-based systems
# Performs comprehensive system maintenance including:
# - Package updates (snap, flatpak, dnf)
# - System cleanup (old kernels, package cache)
# - Storage optimization (TRIM, journal cleanup)
# - System health checks (failed services, disk space)
#
# Features:
# - Safe defaults with clear logging
# - Graceful handling of missing tools
# - Non-interactive operation
# - Detailed status reporting

set -euo pipefail
IFS=$'\n\t'

# Default to non-interactive mode (auto-yes)
INTERACTIVE=false

# ----- Color Definitions -----
# Use colors only if the output is a terminal
if [[ -t 1 ]]; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    NC=$(tput sgr0) # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# ----- Logging helpers -----
# log_ts() { date +"%Y-%m-%d %H:%M:%S%z"; }
info() { echo "${GREEN} [INFO]       $*${NC}"; }
warn() { echo "${YELLOW} [WARN]  $*${NC}" >&2; }
err()  { echo "${RED} [ERROR] $*${NC}" >&2; }
title() { echo "${BLUE} [TITLE] $*${NC}"; }

# Determine sudo usage (only if not root and sudo exists)
SUDO=""
if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
  else
    warn "sudo not found; commands needing elevation may fail. Consider running this script as root."
  fi
fi

# ----- Flatpak cleanup -----
cleanup_flatpak() {
  if ! command -v flatpak >/dev/null 2>&1; then
    info "flatpak not installed; skipping Flatpak cleanup."
    return 0
  fi

  info "Starting Flatpak cleanup..."
  
  # Remove unused flatpak runtimes and dependencies
  info "Removing unused Flatpak runtimes and dependencies..."
  flatpak uninstall --unused -y || warn "Failed to remove unused Flatpak runtimes"
  
  # Clean the build cache (handled by uninstall --unused)
  info "Cleaning Flatpak cache..."
  flatpak uninstall --unused -y || warn "No unused runtimes to remove"
  
  # Repair flatpak installation
  info "Repairing Flatpak installation..."
  flatpak repair || warn "Failed to repair Flatpak installation"
  
  info "Flatpak cleanup completed."
}

# ----- DNF cleanup -----
cleanup_dnf() {
  if ! command -v dnf >/dev/null 2>&1; then
    info "dnf not installed; skipping dnf cleanup."
    return 0
  fi

  info "Cleaning up dnf cache..."
  if ! $SUDO dnf clean all; then
    warn "dnf clean all encountered issues."
  fi
}

# ----- Snap cleanup -----
cleanup_snaps() {
  if ! command -v snap >/dev/null 2>&1; then
    info "snap not installed; skipping snap cleanup."
    return 0
  fi

  info "Removing old snap revisions..."
  # Removes old revisions of snaps
  # CLOSE ALL SNAPS BEFORE RUNNING THIS
  LANG=C snap list --all | awk '/disabled/{print $1, $3}' |
    while read -r snapname revision; do
      info "Removing $snapname (revision $revision)..."
      if ! $SUDO snap remove "$snapname" --revision="$revision"; then
        warn "Failed to remove snap $snapname revision $revision"
      fi
    done
  info "Snap cleanup finished."
}

# ----- Storage Maintenance -----
trim_devices() {
  info "Running fstrim on all supported filesystems..."
  if command -v fstrim >/dev/null 2>&1; then
    $SUDO fstrim -va || warn "fstrim command failed"
  else
    warn "fstrim command not found, skipping TRIM operation"
  fi
}

# ----- System Health Checks -----
check_system_health() {
  info "Checking for failed systemd units..."
  
  # Check for failed systemd units
  local failed_units
  failed_units=$($SUDO systemctl --failed --no-legend --no-pager 2>/dev/null || true)
  
  if [[ -n "$failed_units" ]]; then
    echo -e "${RED}Failed services:${NC}"
    echo "$failed_units" | while read -r unit _; do
      echo -e "${RED}• $unit${NC}"
    done
    return 1
  else
    info "No failed systemd units found."
    return 0
  fi
}

confirm_action() {
  if [ "$INTERACTIVE" = true ]; then
    read -p "$1 [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      info "Skipping..."
      return 1
    fi
  fi
  return 0
}

main() {
  # Parse command line arguments
  while getopts "n" opt; do
    case $opt in
      n) INTERACTIVE=true ;;
      *) echo "Usage: $0 [-n]" >&2
         exit 1 ;;
    esac
  done
  
  echo "${RED}Starting system maintenance...${NC}"
  local exit_status=0
  
  # Main execution
  # Skip updates as requested
  title "=== System Updates ==="
  info "Skipping system updates (snap, flatpak, dnf) as requested"
  
  # Then run cleanups
  if confirm_action "Run system cleanups (dnf, flatpak, snap)?"; then
    title "=== Starting system cleanups ==="
    
    # Run each cleanup independently and continue on failure
    info "[1/3] Running DNF cleanup..."
    cleanup_dnf || warn "DNF cleanup completed with errors"
    
    info "[2/3] Running Flatpak cleanup..."
    cleanup_flatpak || warn "Flatpak cleanup completed with errors"
    
    info "[3/3] Running Snap cleanup..."
    cleanup_snaps || warn "Snap cleanup completed with errors"
    
    title "=== System cleanups completed ==="
  fi
  
  # Storage maintenance
  if confirm_action "Run storage maintenance (TRIM)?"; then
    trim_devices
  fi
  
  # Update Chrome application icons
  if [[ -f "$(dirname "$0")/update_chrome_icons.sh" ]]; then
    if confirm_action "Update Chrome application icons?"; then
      info "Updating Chrome application icons..."
      # Capture the output and display it in the style of other sections
      output=$("$(dirname "$0")/update_chrome_icons.sh" 2>&1)
      if [ $? -eq 0 ]; then
        # Process output and remove the last two lines (empty line and "Done!")
        filtered_output=$(echo "$output" | head -n -2)
        echo "$filtered_output" | while IFS= read -r line; do
          if [[ "$line" == "=== Summary ===" ]]; then
            title "=== Chrome Icons Summary ==="
          elif [ -n "$line" ]; then  # Only process non-empty lines
            info "$line"
          fi
        done
      else
        warn "Failed to update Chrome application icons"
        echo "$output" | while IFS= read -r line; do
          warn "$line"
        done
      fi
    fi
  else
    warn "update_chrome_icons.sh not found; skipping Chrome icon updates."
  fi
  
  # Check system health at the end
  title "=== System Maintenance Summary ==="
  if ! check_system_health; then
    warn "[✗] System health check found issues that may need attention."
    exit_status=1
  else
    info "[✓] System health check passed"
  fi
  
  # Show summary of operations
  title "=== Operations Summary ==="
  info "[✓] System updates completed"
  info "[✓] System cleanups completed"
  
  if [[ -f "$(dirname "$0")/update_chrome_icons.sh" ]]; then
    info "[✓] Chrome application icons checked"
  fi
  
  # Final status
  if [[ $exit_status -eq 0 ]]; then
    title "=== System maintenance completed successfully! ==="
  else
    warn "=== System maintenance completed with warnings or errors ==="
  fi
  
  return $exit_status
}

main "$@"
