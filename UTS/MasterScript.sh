#!/bin/bash

#!/bin/bash

# Function to display the menu
display_menu() {
    echo "Please choose an option:"
    echo "1) Edit Kernel Settings"
    echo "2) Search for Files"
    echo "3) Edit login.defs settings"
    echo "4) Edit Visudo Settings"
    echo "5) Upgrade Systems"
    echo "6) Root Imposters"
    echo "7) Check Cron Jobs"
    echo "8) Secure Apt"
    echo "100) Critical service"
    echo "101) Exit"
}

# Function to handle the user's choice
run_choice() {
    case $1 in
    #Main Jobs
        1)
            echo "Running Kernel Editor..."
            # Insert the code to run the kernel editor script here
            sudo ./Kernal.sh
            ;;
        2)
            echo "Running File Search..."
            # Insert the code to run the file search script here
            sudo ./FileSearch.sh
            ;;
        3)
            echo "Running login.defs editor..."
            # Insert the code to run the file search script here
            sudo ./edit_login_defs.sh
            ;;
        4)
            echo "Running Visudo editor..."
            # Insert the code to run the file search script here
            sudo ./VisudoCode.sh
            ;;
        5)
            echo "Updating and upgrading authorized systems..."
            sudo ./upgrade_systems.sh
            ;;
        6)
            echo "Finding root imposters"
            sudo ./RTI.sh

            ;;
        7)
            echo "Checking crontabs..."
            sudo ./list_cron_jobs.sh
            ;;
        8)
            echo "Applying APT configs"
            sudo ./apt_config
            ;;
    #Custom Jobs
        100)
            echo "Welcome to the critical services portion!"
            echo "This script will redirect you to our Critical services script as this is a seperate field!"
            sudo ./CriticalServices.sh
            ;;
        101)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option, please choose again."
            ;;
    esac
}

# Main loop
while true; do
    display_menu
    read -p "Enter your choice, Custom Jobs are 100 and 101: " choice
    run_choice $choice
done
