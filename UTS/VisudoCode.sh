#!/bin/bash

# Define the settings to be added
sudoers_settings="
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL

# Defaults settings
Defaults    env_reset
Defaults    mail_badpass
Defaults    secure_path=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"

# Allow passwordless sudo for members of the admin group
%admin ALL=(ALL) NOPASSWD:ALL
"

# Backup the original sudoers file
backup_file="/etc/sudoers.bak"
echo "Creating backup of the original sudoers file at $backup_file"
sudo cp /etc/sudoers $backup_file

# Create a temporary file for editing
temp_sudoers=$(mktemp)
sudo cp /etc/sudoers $temp_sudoers

# Append the settings to the temporary file
echo "$sudoers_settings" | sudo tee -a $temp_sudoers > /dev/null

# Use visudo to validate and update the sudoers file
echo "Updating /etc/sudoers with standard settings..."
if sudo visudo -c -f $temp_sudoers; then
    sudo cp $temp_sudoers /etc/sudoers
    echo "Successfully updated /etc/sudoers."
else
    echo "Error: Failed to validate sudoers changes. No changes made."
fi

# Clean up the temporary file
rm -f $temp_sudoers
