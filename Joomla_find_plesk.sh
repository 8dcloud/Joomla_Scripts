#!/bin/bash

# Search for all Joomla installations and loop through them
while read -r site; do

    # Extract the site name and path from the site entry
    site_name=$(echo "$site" | cut -d: -f1)
    site_path=$(echo "$site" | cut -d: -f2)

    # Check if the site path exists and has the Joomla version.php file
    if [ -d "$site_path" ] && [ -f "$site_path/httpdocs/includes/version.php" ]; then
        # Search for the Joomla version in the site path
        joomla_version=$(grep -oE "\$RELEASE\s?=\s?[\'\"]Joomla![0-9]+\.[0-9]+\.[0-9]+[\'\"];" "$site_path/httpdocs/includes/version.php" | grep -oE "Joomla![0-9]+\.[0-9]+\.[0-9]+")

        # Output the Joomla version and site name
        echo "Joomla version: $joomla_version - Site: $site_name"
    fi

done < <(plesk bin subscription -l | awk -F':' '{print $1":"$10"/httpdocs"}')
