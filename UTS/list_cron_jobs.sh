#!/bin/bash

# Function to list and explain cron jobs
list_and_explain_cron_jobs() {
    echo "Listing all cron jobs and their explanations..."

    # Define the explanation function for each cron job
    explain_job() {
        local job="$1"
        if [[ $job == *"sh"* || $job == *"bash"* || $job == *"zsh"* ]]; then
            echo "Runs a shell script or command."
        elif [[ $job == *"python"* ]]; then
            echo "Runs a Python script."
        elif [[ $job == *"perl"* ]]; then
            echo "Runs a Perl script."
        elif [[ $job == *"php"* ]]; then
            echo "Runs a PHP script."
        elif [[ $job == *"rsync"* ]]; then
            echo "Runs a file synchronization task."
        elif [[ $job == *"backup"* ]]; then
            echo "Runs a backup task."
        elif [[ $job == *"update"* ]]; then
            echo "Runs a system update or upgrade."
        else
            echo "Unknown or custom job."
        fi
    }

    # Check system-wide cron jobs
    echo -e "\nSystem-wide cron jobs:"
    for file in /etc/crontab /etc/cron.d/*; do
        if [[ -f $file ]]; then
            echo -e "\n$file:"
            grep -v '^#' "$file" | while IFS= read -r line; do
                echo "$line"
                explain_job "$line"
            done
        fi
    done

    # Check root user's cron jobs
    echo -e "\nRoot's crontab:"
    sudo crontab -l -u root 2>/dev/null | while IFS= read -r line; do
        echo "$line"
        explain_job "$line"
    done

    # Check other users' cron jobs
    echo -e "\nOther users' crontabs:"
    for user in $(cut -f1 -d: /etc/passwd); do
        if [[ $user != "root" ]]; then
            echo -e "\n$user's crontab:"
            sudo crontab -l -u "$user" 2>/dev/null | while IFS= read -r line; do
                echo "$line"
                explain_job "$line"
            done
        fi
    done
}

# Run the function
list_and_explain_cron_jobs
