#!/bin/bash

# Function to check for root imposters excluding the root user
check_root_imposters() {
    echo "Checking for root imposters (excluding the root user)..."
    awk -F: '($3 == 0 && $1 != "root") {print "Root UID 0 detected for user: " $1}' /etc/passwd
}

# Function to check for users with invalid UIDs
check_invalid_uids() {
    echo "Checking for users with invalid UIDs..."
    awk -F: '($3 < 0 || $3 > 65535) {print "Invalid UID detected for user: " $1 " (UID: " $3 ")"}' /etc/passwd
}

# Main script execution
check_root_imposters
check_invalid_uids

echo "User check completed."
