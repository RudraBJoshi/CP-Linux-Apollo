#!/bin/bash

# Define the file types to search for
file_types=("*.wav" "*.mp3" "*.mp4" "*.sh" ".py")

# Define the search location (root directory)
search_location="/"

# Function to search for files
search_files() {
    local file_type="$1"
    echo "Searching for $file_type files..."
    find "$search_location" -type f -name "$file_type" 2>/dev/null
}

# Loop through each file type and perform the search
for file_type in "${file_types[@]}"; do
    search_files "$file_type"
done

echo "Search completed."
