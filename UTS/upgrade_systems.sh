#!/bin/bash

# Function to update and upgrade the system
update_system() {
    echo "Updating package lists..."
    sudo apt-get update -y
    
    echo "Upgrading all packages..."
    sudo apt-get upgrade -y
    
    echo "Upgrading distribution..."
    sudo apt-get dist-upgrade -y
    
    echo "Cleaning up unused packages..."
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y
}

# Function to upgrade the kernel
upgrade_kernel() {
    echo "Upgrading the kernel..."
    sudo apt-get install --install-recommends linux-generic -y
}

# Function to upgrade Firefox
upgrade_firefox() {
    echo "Upgrading Firefox..."
    sudo apt-get install --only-upgrade firefox -y
}

# Main script execution
echo "Starting update and upgrade process..."

update_system
upgrade_kernel
upgrade_firefox

echo "Update and upgrade process completed."
