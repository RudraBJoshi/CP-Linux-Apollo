#!/bin/bash

# Path to APT configuration directories
APT_CONF_DIR="/etc/apt/apt.conf.d"
APT_SOURCES_DIR="/etc/apt/sources.list.d"

# Function to apply recommended settings
apply_recommended_settings() {
    echo "Applying recommended APT settings..."

    # Example: Enforce HTTPS for package downloads
    echo "Enforcing HTTPS for APT sources..."
    sed -i 's|http://|https://|g' /etc/apt/sources.list
    find $APT_SOURCES_DIR -type f -name "*.list" -exec sed -i 's|http://|https://|g' {} \;

    # Example: Enable automatic updates
    AUTO_UPGRADE_CONF="/etc/apt/apt.conf.d/20auto-upgrades"
    echo "Configuring automatic updates..."
    cat <<EOF > $AUTO_UPGRADE_CONF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF
}

# Function to remove potentially malicious configurations
remove_malicious_configs() {
    echo "Scanning for potentially malicious APT configurations..."

    # Example: Remove any sources pointing to non-official repositories
    echo "Removing non-official repositories..."
    find $APT_SOURCES_DIR -type f -name "*.list" | while read -r file; do
        grep -qE 'deb\s+http://non-official-repo|deb\s+https://non-official-repo' "$file" && rm -f "$file"
    done

    # Example: Remove unnecessary APT config files
    echo "Removing unnecessary APT configuration files..."
    find $APT_CONF_DIR -type f -name "*.conf" | while read -r file; do
        grep -qE 'APT::Get::AllowUnauthenticated|APT::Install-Suggests' "$file" && rm -f "$file"
    done
}

# Function to leave neutral configurations unchanged
leave_neutral_configs_alone() {
    echo "Leaving neutral configurations unchanged..."
    # No action is needed as we're only applying recommended settings and removing malicious ones
}

# Main script execution
apply_recommended_settings
remove_malicious_configs
leave_neutral_configs_alone

echo "APT configuration adjustments completed."
