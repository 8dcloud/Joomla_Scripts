#!/bin/bash

####################################################
#                                                  #
#         Simple Script J! SMTP info               #
#         8Dweb LLC / mjs                          #
#         01/03/2025                               #
####################################################
# Directory to search in
search_dir="/var/www/"

# Strings to search and replace
search_string="smtp15.cmsdefender.com"
replace_string="mail.cmsdefender.com"

# Output file
output_file="replaced_files.txt"

# Clear the output file if it exists
> "$output_file"

# Find all configuration.php files and replace the string
find "$search_dir" -type f -name "configuration.php" | while read -r file; do
    if grep -q "$search_string" "$file"; then
        # Replace the string in the file
        sed -i "s/$search_string/$replace_string/g" "$file"
        echo "Replaced '$search_string' with '$replace_string' in: $file"
        echo "$file" >> "$output_file"
    fi
done

echo "List of modified files saved to $output_file"
