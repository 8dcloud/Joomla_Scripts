#!/bin/bash

# Directories to search for Joomla installations
# - OLD does nto work well: search_dirs=("/var/www/*/httpdocs" "/var/www/*/public_html")
# - simplified version:
search_dirs=("/var/www/")

# Function to extract Joomla version
get_joomla_version() {
    if [ -f "$1/administrator/manifests/files/joomla.xml" ]; then
        version=$(grep -oPm1 "(?<=<version>)[^<]+" "$1/administrator/manifests/files/joomla.xml")
        echo "$version"
    else
        echo ""
    fi
}

# Function to extract the site name from configuration.php
get_site_name() {
    if [ -f "$1/configuration.php" ]; then
        site_name=$(awk -F"'" '/public \$sitename/ {print $2}' "$1/configuration.php")
        echo "$site_name"
    else
        echo ""
    fi
}

# Search for Joomla installations
echo "Searching for Joomla sites in ${search_dirs[@]}..."
echo "-----------------------------------------------"

for dir in "${search_dirs[@]}"; do
    find "$dir" -type f -name "configuration.php" | while read -r config_file; do
        # Extract the directory where configuration.php is located
        site_dir=$(dirname "$config_file")
        
        # Extract Joomla version
        joomla_version=$(get_joomla_version "$site_dir")

        # If joomla_version is not empty, it's a Joomla site
        if [ -n "$joomla_version" ]; then
            # Extract Site Name
            site_name=$(get_site_name "$site_dir")
            
            # Handle case when site name is not found
            if [ -z "$site_name" ]; then
                site_name="Site name not found"
            fi

            # Output in formatted style with site name in header
            echo "-----------------------------------------------"
            echo "Joomla Site Found: $site_name"
            echo "-----------------------------------------------"
            echo "• **Site Directory:** $site_dir"
            echo "• **Site Name:** $site_name"
            echo "• **Joomla Version:** $joomla_version"
            echo "-----------------------------------------------"
            echo ""
        fi
    done
done
