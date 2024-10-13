#!/bin/bash

# Define the SSH configuration file path
sshd_config="/etc/ssh/sshd_config"

# Backup the original SSH configuration file
backup_file="/etc/ssh/sshd_config.bak"
echo "Creating backup of the original SSH configuration file at $backup_file"
sudo cp $sshd_config $backup_file

# Define the standard SSH settings
ssh_settings=(
    "Port 22"                            # Default SSH port
    "Protocol 2"                         # Use SSH protocol 2 only
    "PermitRootLogin no"                 # Disable root login
    "PasswordAuthentication yes"         # Enable password authentication
    "ChallengeResponseAuthentication no" # Disable challenge-response authentication
    "UsePAM yes"                         # Enable PAM
    "X11Forwarding no"                   # Disable X11 forwarding
    "PermitEmptyPasswords no"            # Disallow empty passwords
    "ClientAliveInterval 300"            # Interval for client keep-alive messages
    "ClientAliveCountMax 2"              # Maximum number of client keep-alive messages
    "AllowTcpForwarding yes"             # Allow TCP forwarding
    "MaxAuthTries 3"                     # Limit the number of authentication attempts
    "LoginGraceTime 1m"                  # Time allowed for successful authentication
    "LogLevel VERBOSE"                   # Set log level to VERBOSE
    "AllowGroups sshusers"               # Allow only members of the sshusers group
)

# Update or add settings in the SSH configuration file
for setting in "${ssh_settings[@]}"; do
    key=$(echo "$setting" | awk '{print $1}')
    value=$(echo "$setting" | cut -d' ' -f2-)
    if grep -q "^$key" $sshd_config; then
        sudo sed -i "s/^$key.*/$key $value/" $sshd_config
    else
        echo "$setting" | sudo tee -a $sshd_config > /dev/null
    fi
done

# Restart SSH service to apply changes
echo "Restarting SSH service..."
sudo systemctl restart ssh

echo "OpenSSH configuration updated with standard settings."
