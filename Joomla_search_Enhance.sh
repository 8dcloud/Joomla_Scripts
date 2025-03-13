#!/bin/bash

####################################################
#                                                  #
#         Simple Script to Find NIC Speed          #
#         8Dweb LLC / mjs                          #
#         01/03/2025                               #
####################################################

# Define the base directory for all websites
base_dir="/var/www/"
# Define the output CSV file
output_file="joomla_sites.csv"

# Write the CSV header
echo "Website Name (Owner),Directory,Configuration File Path" > "$output_file"

# Loop through each UID folder in the base directory
for uid_dir in "$base_dir"*/; do
    # Get the owner of the UID folder
    folder_owner=$(stat -c '%U' "$uid_dir")

    # Check for Joomla configuration.php file in public_html and httpdocs
    for sub_dir in "public_html" "httpdocs"; do
        config_file="${uid_dir}${sub_dir}/configuration.php"
        if [ -f "$config_file" ]; then
            # Write the folder owner (website name), directory, and configuration file path to the CSV
            echo "\"$folder_owner\",\"${uid_dir}${sub_dir}\",\"$config_file\"" >> "$output_file"
        fi
    done
done

echo "Scan complete. Results saved to $output_file."
