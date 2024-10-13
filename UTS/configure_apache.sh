#!/bin/bash

# Define the Apache configuration file path
apache_conf="/etc/apache2/apache2.conf"
backup_file="/etc/apache2/apache2.conf.bak"

# Backup the original Apache configuration file
echo "Creating backup of the original Apache configuration file at $backup_file"
sudo cp $apache_conf $backup_file

# Define the standard Apache settings
apache_settings=(
    "ServerTokens Prod"          # Send minimal information about the server
    "ServerSignature Off"        # Disable server version information on error pages
    "TraceEnable Off"            # Disable HTTP TRACE method
    "Timeout 300"                # Set request timeout to 300 seconds
    "KeepAlive On"               # Enable persistent connections
    "MaxKeepAliveRequests 100"   # Maximum number of requests allowed per persistent connection
    "KeepAliveTimeout 5"         # Timeout for keep-alive connections
    "User www-data"              # User Apache will run as
    "Group www-data"             # Group Apache will run as
    "LogLevel warn"              # Set the logging level to warning
    "ErrorLog ${APACHE_LOG_DIR}/error.log"  # Path to error log file
    "CustomLog ${APACHE_LOG_DIR}/access.log combined"  # Path to access log file
)

# Update or add settings in the Apache configuration file
for setting in "${apache_settings[@]}"; do
    key=$(echo "$setting" | awk '{print $1}')
    value=$(echo "$setting" | cut -d' ' -f2-)
    if grep -q "^$key" $apache_conf; then
        sudo sed -i "s/^$key.*/$key $value/" $apache_conf
    else
        echo "$setting" | sudo tee -a $apache_conf > /dev/null
    fi
done

# Restart Apache service to apply changes
echo "Restarting Apache service..."
sudo systemctl restart apache2

echo "Apache configuration updated with standard settings."
