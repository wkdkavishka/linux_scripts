#!/bin/bash

# Configuration
APPS_DIR="$HOME/.local/share/applications"
ICONS_DIR="$HOME/.local/share/icons/hicolor/256x256/apps"
BACKUP_DIR="$HOME/.local/share/applications/backups"

# Create backup directory
mkdir -p "$BACKUP_DIR" || {
    echo "Error: Failed to create backup directory"
    exit 1
}

# Initialize counters
processed=0
updated=0
errors=0

# Find all Chrome desktop files and store in array
file_list=()
while IFS= read -r -d $'\0' file; do
    file_list+=("$file")
done < <(find "$APPS_DIR" -name 'chrome-*-Default.desktop' -print0)

echo -e "Found ${#file_list[@]} Chrome desktop files to process\n"

# Process each file
for file in "${file_list[@]}"; do
    echo "Processing: $(basename "$file")"
    
    # Extract app ID from filename
    if [[ "$file" =~ chrome-(.*)-Default\.desktop$ ]]; then
        app_id="${BASH_REMATCH[1]}"
        icon_path="$ICONS_DIR/chrome-${app_id}-Default.png"
        
        # Create backup
        backup_file="${BACKUP_DIR}/$(basename "$file").bak"
        if cp "$file" "$backup_file"; then
            echo "  ✓ Backup created: $(basename "$backup_file")"
            
            # Update icon path in the desktop file
            if sed -i "s|^Icon=.*|Icon=${icon_path%.png}|" "$file"; then
                echo "  ✓ Updated icon path to: $icon_path"
                ((updated++))
            else
                echo "  ✗ Failed to update icon path"
                ((errors++))
            fi
        else
            echo "  ✗ Failed to create backup, skipping file"
            ((errors++))
            continue
        fi
    else
        echo "  ✗ Invalid filename format, skipping"
        ((errors++))
        continue
    fi
    
    ((processed++))
    echo ""  # Add empty line between files
done

# Print summary
echo "=== Summary ==="
echo "Processed: $processed files"
echo "Updated: $updated files"
echo "Errors: $errors"

if [ $updated -gt 0 ]; then
    echo -e "\nBackups saved in: $BACKUP_DIR"
fi

echo -e "\nDone!"

