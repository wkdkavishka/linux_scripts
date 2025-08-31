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
    NC=$(tput sgr0) # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    NC=''
fi

# ----- Logging helpers -----
log_ts() { date +"%Y-%m-%d %H:%M:%S%z"; }
info() { echo "${GREEN}[$(log_ts)] [INFO]       $*${NC}"; }
warn() { echo "${YELLOW}[$(log_ts)] [WARN]  $*${NC}" >&2; }
err()  { echo "${RED}[$(log_ts)] [ERROR] $*${NC}" >&2; }

# Determine sudo usage (only if not root and sudo exists)
SUDO=""
if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
  else
    warn "sudo not found; commands needing elevation may fail. Consider running this script as root."
  fi
fi

# ----- Snap update -----
update_snap() {
  if command -v snap >/dev/null 2>&1; then
    info "Updating snaps..."
    if ! snap refresh; then
      warn "Snap refresh encountered issues."
    fi
  else
    info "snap not installed; skipping snaps."
  fi
}

# ----- Flatpak update -----
update_flatpak() {
  if command -v flatpak >/dev/null 2>&1; then
    info "Updating Flatpak apps and runtimes..."
    # Non-interactive updates
    if ! flatpak update -y; then
      warn "Flatpak update encountered issues."
    fi
  else
    info "flatpak not installed; skipping Flatpak."
  fi
}

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
  
  # Clean the build cache
  info "Cleaning Flatpak build cache..."
  flatpak build-cleanup || warn "Failed to clean Flatpak build cache"
  
  # Remove old versions of installed applications
  info "Removing old Flatpak versions..."
  flatpak uninstall --delete-data -y || warn "Failed to remove old Flatpak versions"
  
  # Clean the flatpak cache
  info "Cleaning Flatpak cache..."
  flatpak repair || warn "Failed to repair Flatpak installation"
  
  info "Flatpak cleanup completed."
}

# ----- DNF update -----
update_dnf() {
  if command -v dnf >/dev/null 2>&1; then
    info "Refreshing metadata and upgrading system packages via dnf..."
    # Prefer upgrade --refresh, fallback to update -y if needed
    if ! $SUDO dnf upgrade --refresh -y; then
      warn "dnf upgrade --refresh failed; trying dnf update -y."
      if ! $SUDO dnf update -y; then
        err "dnf update failed."
        return 1
      fi
    fi
  else
    info "dnf not installed; skipping dnf."
  fi
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
  # Set language to C to ensure consistent output from snap list
  LANG=C snap list --all | awk '/disabled/{print $1, $3}' | while read -r name rev; do
    info "Removing $name (revision $rev)..."
    if ! $SUDO snap remove "$name" --revision="$rev"; then
      warn "Failed to remove snap $name revision $rev."
    fi
  done
  info "Snap cleanup finished."
}

# ----- Storage Maintenance -----
trim_devices() {
  info "Running fstrim on all supported filesystems..."
  $SUDO fstrim -vs
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
  
  info "Starting system maintenance..."
  local exit_status=0
  
  # Main execution
  # Run updates first
  if confirm_action "Run system updates (snap, flatpak, dnf)?"; then
    info "=== Starting system updates ==="
    
    # Run each update independently and continue on failure
    info "[1/3] Running Snap updates..."
    update_snap || warn "Snap update completed with errors"
    
    info "[2/3] Running Flatpak updates..."
    update_flatpak || warn "Flatpak update completed with errors"
    
    info "[3/3] Running DNF updates..."
    update_dnf || warn "DNF update completed with errors"
    
    info "=== System updates completed ==="
  fi
  
  # Then run cleanups
  if confirm_action "Run system cleanups (dnf, flatpak, snap)?"; then
    info "=== Starting system cleanups ==="
    
    # Run each cleanup independently and continue on failure
    info "[1/3] Running DNF cleanup..."
    cleanup_dnf || warn "DNF cleanup completed with errors"
    
    info "[2/3] Running Flatpak cleanup..."
    cleanup_flatpak || warn "Flatpak cleanup completed with errors"
    
    info "[3/3] Running Snap cleanup..."
    cleanup_snaps || warn "Snap cleanup completed with errors"
    
    info "=== System cleanups completed ==="
  fi
  
  # Storage maintenance
  if confirm_action "Run storage maintenance (TRIM)?"; then
    trim_devices
  fi
  
  # Update Chrome application icons
  if [[ -f "$(dirname "$0")/update_chrome_icons.sh" ]]; then
    if confirm_action "Update Chrome application icons?"; then
      info "Updating Chrome application icons..."
      "$(dirname "$0")/update_chrome_icons.sh"
    fi
  else
    warn "update_chrome_icons.sh not found; skipping Chrome icon updates."
  fi
  
  # Check system health at the end
  if ! check_system_health; then
    warn "System health check found issues that may need attention."
    exit_status=1
  fi
  
  if [[ $exit_status -eq 0 ]]; then
    info "System maintenance completed successfully!"
  else
    warn "System maintenance completed with warnings or errors."
  fi
  
  return $exit_status
}

main "$@"
