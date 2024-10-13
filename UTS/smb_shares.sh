#!/bin/bash

# Path to Samba configuration file
SMB_CONF="/etc/samba/smb.conf"

# List of necessary shares (these will be kept)
NECESSARY_SHARES=("homes" "printers" "print$")

# Function to parse and print all custom shares
print_custom_shares() {
    echo "Listing custom Samba shares..."
    grep "^\[" $SMB_CONF | sed 's/\[//;s/\]//' | while read -r share; do
        if [[ ! " ${NECESSARY_SHARES[@]} " =~ " ${share} " ]]; then
            echo "Custom share found: $share"
        fi
    done
}

# Function to choose which custom shares to keep
choose_shares_to_keep() {
    echo "Select which custom shares to keep (separate choices with spaces):"
    custom_shares=()
    grep "^\[" $SMB_CONF | sed 's/\[//;s/\]//' | while read -r share; do
        if [[ ! " ${NECESSARY_SHARES[@]} " =~ " ${share} " ]]; then
            custom_shares+=("$share")
        fi
    done

    echo "Available custom shares: ${custom_shares[@]}"
    read -p "Enter the shares you want to keep: " -a shares_to_keep

    echo "Keeping the following custom shares: ${shares_to_keep[@]}"
    echo "Cleaning up the Samba configuration file..."

    # Backup the original config file
    cp $SMB_CONF "${SMB_CONF}.bak"

    # Start building a new smb.conf
    awk -v shares="${shares_to_keep[*]}" -v necessary="${NECESSARY_SHARES[*]}" '
    BEGIN {
        split(shares, keep_shares)
        split(necessary, necessary_shares)
        keep_shares_map_size = length(keep_shares)
        necessary_shares_map_size = length(necessary_shares)
    }
    /^\[.*\]$/ {
        section = $0
        gsub(/\[|\]/, "", section)
        if (section in keep_shares || section in necessary_shares) {
            print_section = 1
        } else {
            print_section = 0
        }
    }
    {
        if (print_section) {
            print $0
        }
    }
    ' $SMB_CONF > "${SMB_CONF}.new"

    # Replace the old config file with the new one
    mv "${SMB_CONF}.new" $SMB_CONF
    echo "Samba configuration updated successfully."
}

# Main script execution
print_custom_shares
choose_shares_to_keep

echo "Samba share management completed."
