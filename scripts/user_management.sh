#!/bin/bash




# Function to display user information
display_users() {
    echo "
++---------------------User List---------------------++

  "
    local filter_system_users="$1"
    local show_details="$2"
    
    # Base command to get user info, adjustable for different formats
    user_data=$(getent passwd) 

    # Filtering (optional)
    if [[ "$filter_system_users" == "yes" ]]; then
        user_data=$(echo "$user_data" | awk -F: '$3 >= 1000 {print}') 
    fi
    
    # Display options
    if [[ "$show_details" == "yes" ]]; then
        echo "$user_data" | awk -F: '{printf "%-15s %-10s %-20s %-30s\n", $1, $3, $4, $5}'
    else
        echo "$user_data" | cut -d: -f1 # Just usernames
    fi
}


#adding user to the operating system
add_user() {
  if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run this function as root."
  fi

  display_users "y" "n"

  read -p "Enter the username for the new user: " username

  # This is to check if the newly created user already exists
  if id "$username" >/dev/null 2>&1; then
    echo "Error: User '$username' already exists!"
  else
    # Prompt for the default password
    read -p "Enter default password for '$username': " default_password

    # Adds user with default password
    useradd -m -s /bin/bash "$username"

    echo "$username:$default_password" | chpasswd

    echo "User '$username' added with the default password."
  fi
}

delete_user() {
  if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run this function as root."
  fi

  display_users "y" "n"

  read -p "Enter the username to delete: " username

  # Check if the user exists
  if ! id "$username" >/dev/null 2>&1; then
    echo "Error: User '$username' does not exist."
  fi

  # Ask for confirmation before deletion
  read -p "Are you sure you want to delete user '$username'? (y/n): " confirm
  if [ "$confirm" != "y" ]; then
    echo "Deletion canceled."
  fi

  # Choose deletion options
  echo "Choose deletion options:"
  echo "1. Delete user only (keep home directory and mail spool)"
  echo "2. Delete user and home directory"
  read -p "Enter your choice (1 or 2): " choice

  case $choice in
    1) userdel "$username" ;;
    2) userdel -r "$username" ;;
    *) echo "Invalid choice. Deletion canceled." ;;
  esac

  if [ $? -eq 0 ]; then  # Check the exit status of the userdel command
    echo "User '$username' deleted successfully."
  else
    echo "Error: Failed to delete user '$username'."
  fi
}

#disable user within the server
disable_user() {
  if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root."
  fi

  display_users "y" "n"

  read -p "Enter the username you wish to disable: " username

  # Check username existence
  if id "$username" >/dev/null 2>&1; then
    read -p "Are you sure you wish to disable user '$username'? (Y/N): " confirmation

    if [ "$confirmation" == "Y" ]; then
      passwd -l "$username"
      echo "User '$username' has been disabled."
    else
      echo "User '$username' was not disabled."
    fi
  else
    echo "Error: User '$username' does NOT exist."
  fi
}

