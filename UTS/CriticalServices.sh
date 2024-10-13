#!/bin/bash

# Function to display the menu
display_menu() {
    echo "Please choose a service to configure:"
    echo "1) SSH"
    echo "2) VSFTPD"
    echo "3) Apache2"
    echo "4) Samba Shares"
    echo "5) Samba Configs"
    echo "6) "
    echo "100) Exit"
}

# Function to handle the user's choice
run_choice() {
    case $1 in
        1)
            echo "Running SSH configuration..."
            # Path to the SSH configuration script
            sudo ./configure_openssh.sh
            ;;
        2)
            echo "Running VSFTPD configuration"
            # Path to the VSFTPD configuration script
            sudo ./configure_vsftpd.sh
            ;;
        3)
            echo "Running Apache 2 configuration..."
            # Path to the Apache 2 configuration script
            sudo ./configure_apache2.sh
            ;;
        4)  
            echo "configuring samba shares... (Note: you will have to do some manual work and is not fully automatic)"
            sudo ./smb_shares.sh
            ;;
        5)  
            echo "configuring samba config file (Note: this is different from share configs)"
            sudo ./smb_config
            ;;
        6)
            echo ""
            ;;
        100)
            echo "Exiting...Going back to master script"
            sudo ./MasterScript.sh
            ;;
        *)
            echo "Invalid option, please choose again."
            ;;
    esac
}

# Main loop
while true; do
    display_menu
    read -p "Enter your choice: " choice
    run_choice $choice
done
