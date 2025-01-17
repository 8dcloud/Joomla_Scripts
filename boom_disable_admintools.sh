#!/bin/bash

# Function to find Joomla installations and list directories for renaming
find_and_test() {
    # Initialize an array to store directories to be renamed
    directories_to_rename=()

    # Use a subshell and a command substitution to capture the output from find command
    find_results=$(find /var/www -type d -name "httpdocs" -exec find {} -maxdepth 1 -name "configuration.php" 2>/dev/null \;)

    # Loop through each result from the find command
    while IFS= read -r config_file; do
        # Get the Joomla root directory
        joomla_root=$(dirname "$config_file")

        # Paths to directories to be renamed
        plugin_dir="$joomla_root/plugins/system/admintools"
        plugin_disabled_dir="$joomla_root/plugins/system/admintools.disabled"
        component_dir="$joomla_root/administrator/components/com_admintools"
        component_disabled_dir="$joomla_root/administrator/components/com_admintools.disabled"

        # Check for the plugin directory and prepare for renaming
        if [ -d "$plugin_dir" ]; then
            echo "Found plugin directory to rename: $plugin_dir"
            directories_to_rename+=("$plugin_dir:$joomla_root/plugins/system/.disabled")
        elif [ -d "$plugin_disabled_dir" ]; then
            echo "Found plugin directory already with .disabled: $plugin_disabled_dir"
            directories_to_rename+=("$plugin_disabled_dir:$joomla_root/plugins/system/.disabled")
        fi

        # Check for the component directory and prepare for renaming
        if [ -d "$component_dir" ]; then
            echo "Found component directory to rename: $component_dir"
            directories_to_rename+=("$component_dir:$joomla_root/administrator/components/.disabled")
        elif [ -d "$component_disabled_dir" ]; then
            echo "Found component directory already with .disabled: $component_disabled_dir"
            directories_to_rename+=("$component_disabled_dir:$joomla_root/administrator/components/.disabled")
        fi
    done <<< "$find_results"

    # Prompt user to confirm changes
    if [ ${#directories_to_rename[@]} -gt 0 ]; then
        echo -e "\nThe following directories will be renamed:"
        for dir_pair in "${directories_to_rename[@]}"; do
            IFS=':' read -r source target <<< "$dir_pair"
            echo " - $source  -->  $target"
        done

        # Ask for user confirmation
        read -p "Do you want to proceed with renaming these directories? (y/n): " choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            rename_directories
        else
            echo "Operation canceled by user."
        fi
    else
        echo "No directories found for renaming."
    fi
}

# Function to rename the directories
rename_directories() {
    echo -e "\nRenaming directories..."
    for dir_pair in "${directories_to_rename[@]}"; do
        IFS=':' read -r source target <<< "$dir_pair"
        mv "$source" "$target"
        echo "Renamed $source to $target"
    done
}

# Execute the test function
find_and_test
