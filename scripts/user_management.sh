#!/bin/bash


# Function to display user information (updated)
display_users() {
    echo "
++---------------------User List---------------------++

  "
    local filter_system_users="$1"
    local show_details="$2"
    
    # Base command to get user info (using getent for more robust info)
    user_data=$(getent passwd) 

    # Filtering (optional, exclude system users if $filter_system_users is "yes")
    if [[ "$filter_system_users" == "yes" ]]; then
        user_data=$(echo "$user_data" | awk -F: '$3 >= 1000 {print}') 
    fi
    
    # Display options
    if [[ "$show_details" == "yes" ]]; then
        # Show detailed user information (username, UID, GID, home directory)
        echo "$user_data" | awk -F: '{printf "%-15s %-10s %-20s %-30s\n", $1, $3, $4, $5}'
    else
        # Show only usernames
        echo "$user_data" | cut -d: -f1 
    fi
    echo "
++---------------------------------------------------++

  "
}

#adding user to the operating system
add_user() {
  if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run this function as root."
  fi
  while true; do
    display_users "yes" "yes"
    echo ""
    read -p "Enter the username for the new user: " username

    # Check if username is empty    
    if [[ -z "$username" ]]; then
      echo ""
      read -p "Do you want to try again (Y/n):" try
      if [[ "$try" =~ ^[Nn]$ ]]; then
        break
      fi
      clear 
    # This is to check if the newly created user already exists
    elif id "$username" >/dev/null 2>&1; then
      echo ""
      echo "Error: User '$username' already exists! "
      read -p "Do you want to try again (Y/n):" try
      if [[ "$try" =~ ^[Nn]$ ]]; then
        break
      fi
      clear
    else
      # Prompt for the default password
      read -p "Enter default password for '$username': " default_password

      # Adds user with default password
      useradd -m -s /bin/bash "$username"

      echo "$username:$default_password" | chpasswd
      echo ""
      echo "User '$username' added with the default password."

      sleep 1
      break
      clear
    fi
  done
}

delete_user() {
  if [ "$EUID" -ne 0 ]; then
    echo ""
    echo "Error: Please run this function as root."
  fi
  while true; do
    display_users "yes" "yes"
    echo ""
    echo ""
    read -p "Enter the username to delete: " username

    # Check if username is not empty
    if [[ -z "$username" ]]; then  
      echo ""
      read -p "Do you want to try again (Y/n):" try
      if [[ "$try" =~ ^[Nn]$ ]]; then
        break
      fi
      clear 
    # Check if the user exists
    elif ! id "$username" >/dev/null 2>&1; then
      echo ""
      echo "Error: User '$username' does not exist!"
      echo ""
      read -p "Do you want to try again (Y/n):" try
      if [[ "$try" =~ ^[Nn]$ ]]; then
        break
      fi
      clear
    else
      # Ask for confirmation before deletion
      read -p "Are you sure you want to delete user '$username'? (y/n): " confirm
      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo ""
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
        *)
          echo "" 
          echo "Invalid choice. Deletion canceled." ;;
      esac

      if [ $? -eq 0 ]; then  # Check the exit status of the userdel command
        echo ""
        echo "User '$username' deleted successfully."
      else
        echo ""
        echo "Error: Failed to delete user '$username'."
      fi
      
      sleep 1
      break
      clear
    fi
  done
}

#disable user within the server
disable_user() {
  if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root."
  fi

  while true; do
    display_users "yes" "yes"

    read -p "Enter the username you wish to disable: " username

    # Check if username is not empty
    if [[ -z "$username" ]]; then
      echo ""  
      read -p "Do you want to try again (Y/n):" try
      if [[ "$try" =~ ^[Nn]$ ]]; then
        break
      fi
      clear 
    # Check username existence
    elif id "$username" >/dev/null 2>&1; then
      read -p "Are you sure you wish to disable user '$username'? (Y/N): " confirmation

      if [[ "$confirmation" =~ ^[Yy]$ ]]; then
        passwd -l "$username"
        echo ""
        echo "User '$username' has been disabled."
      else
        echo ""
        echo "User '$username' was not disabled."
        echo ""
        echo "To enabe back the '$username' please modify the user password. Thank You. "
      fi
      sleep 1
      break 
      clear
    else
      echo "Error: User '$username' does NOT exist."
      read -p "Do you want to try again (Y/n):" try
      if [[ "$try" =~ ^[Nn]$ ]]; then
        break
      fi
      clear      
    fi
  done
}

# Function to modify a user's password or username
modify_user() {
  if [ "$EUID" -ne 0 ]; then
      echo "Error: This script must be run as root."
      return 1
  fi

  while true; do
    display_users "yes" "yes"  # Show non-system users with details
    echo ""
    echo ""
    read -p "Enter the username for modification: " username

    # Check if username is empty
    if [[ -z "$username" ]]; then  
      echo ""
      read -p "Do you want to try again (Y/n):" try
      if [[ "$try" =~ ^[Nn]$ ]]; then
        break
      fi
      clear
    # Check username existence 
    elif id "$username" >/dev/null 2>&1; then
      while true; do
        echo "What would you like to modify?"
        echo "1. Password"
        echo "2. Username"
        echo "3. Cancel"

        read -p "Enter your choice: " mod_choice

        case $mod_choice in
          1) 
            passwd "$username" 
            sleep 1
            break
            clear
            ;;
          2) 
            read -p "Enter the new username: " new_username

            # Basic validation for the new username (can be extended)
            if [[ -z "$new_username" || "$new_username" =~ [^a-z0-9_-] ]]; then
              echo ""
              echo "Invalid username. Usernames can only contain lowercase letters, numbers, underscores, and hyphens."
            else
              usermod -l "$new_username" "$username"
              echo ""
              echo "Username changed successfully to '$new_username'."
              sleep 1
              break
              clear
            fi
            ;;
          3) 
            echo ""
            echo "Modification cancelled."
            sleep 1
            break
            clear
            ;;
          *) 
            echo ""
            echo "Invalid choice. Please try again." ;;
        esac
      done
      sleep 1
      break
      clear
    else
        echo ""
        echo "Error: User '$username' does NOT exist."
        sleep 1
        break
        clear
    fi
  done
}
