#!/bin/bash

# Define the configuration file path
VSFTPD_CONF="/etc/vsftpd.conf"

# Backup the original configuration file
cp $VSFTPD_CONF ${VSFTPD_CONF}.backup

# Function to add or update configuration directives
update_config() {
    local directive="$1"
    local value="$2"
    local file="$3"

    if grep -q "^$directive" "$file"; then
        sed -i "s/^$directive=.*/$directive=$value/" "$file"
    else
        echo "$directive=$value" >> "$file"
    fi
}

# Update the configuration directives

# Passive mode settings
update_config "pasv_enable" "YES" "$VSFTPD_CONF"
update_config "pasv_max_port" "3000" "$VSFTPD_CONF"
update_config "pasv_min_port" "3002" "$VSFTPD_CONF"
update_config "connect_from_port_20" "YES" "$VSFTPD_CONF"

# Anonymous settings
update_config "anonymous_enable" "NO" "$VSFTPD_CONF"
update_config "anon_root" "/var/ftp" "$VSFTPD_CONF"
update_config "anon_upload_enable" "NO" "$VSFTPD_CONF"
update_config "anon_mkdir_write_enable" "NO" "$VSFTPD_CONF"
update_config "anon_other_write_enable" "NO" "$VSFTPD_CONF"

# Local settings
update_config "local_enable" "YES" "$VSFTPD_CONF"
update_config "local_root" "/srv/pub" "$VSFTPD_CONF"
update_config "chroot_local_user" "YES" "$VSFTPD_CONF"

# Guest settings
update_config "guest_enable" "YES" "$VSFTPD_CONF"

# Logging settings
update_config "xferlog_enable" "YES" "$VSFTPD_CONF"
update_config "xferlog_std_format" "NO" "$VSFTPD_CONF"
update_config "log_ftp_protocol" "YES" "$VSFTPD_CONF"

# Access control
update_config "download_enable" "NO" "$VSFTPD_CONF"
update_config "max_login_fails" "3" "$VSFTPD_CONF"
update_config "write_enable" "YES" "$VSFTPD_CONF"
update_config "chmod_enable" "NO" "$VSFTPD_CONF"

# Banner and additional settings
update_config "banner_file" "/etc/issue" "$VSFTPD_CONF"

# Restart the vsftpd service to apply changes
systemctl restart vsftpd

echo "VSFTPD configuration updated and service restarted."
