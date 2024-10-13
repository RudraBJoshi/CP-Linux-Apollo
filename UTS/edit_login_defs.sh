#!/bin/bash

# Define the configuration settings
settings=(
    "PASS_MAX_DAYS 90"
    "PASS_MIN_DAYS 7"
    "PASS_WARN_AGE 14"
    "ENCRYPT_METHOD YESCRYPT"
)

# Function to update or add a setting in /etc/login.defs
update_login_defs() {
    local key="$1"
    local value="$2"

    # Use sed to update the setting or append it if it doesn't exist
    if grep -q "^$key" /etc/login.defs; then
        sudo sed -i "s/^$key.*/$key $value/" /etc/login.defs
    else
        echo "$key $value" | sudo tee -a /etc/login.defs > /dev/null
    fi
}

# Update the settings in /etc/login.defs
for setting in "${settings[@]}"; do
    key=$(echo "$setting" | awk '{print $1}')
    value=$(echo "$setting" | awk '{print $2}')
    update_login_defs "$key" "$value"
done

echo "Updated /etc/login.defs with specified password policies."
