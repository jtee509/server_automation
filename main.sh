#!/bin/bash

# Source all the scripts directly
source ./scripts/service_check.sh
source ./scripts/user_management.sh
source ./scripts/system_info.sh
source ./scripts/menu.sh
source ./scripts/logrotation.sh

# Main Script
while true; do
  clear
  #print the menu
  display_menu
  read -r -n 1 -p "

Choose actions that you want to do in a server : " selections

  clear

  case "$selections" in
    # Valid menu options
    1) 
      while true; do
        display_report
        read -r -n 1 -p "

Choose the report to output in the server : " selections
        
        clear 

        case "$selections" in
          1)  
          check_service_status 
          break
          ;;
          2)  analyze_disk_usage ;;
          3)  monitor_cpu_usage ;;
          4)  identify_long_running_processes ;;
          5)  memory_usage_report ;;
          6)  display_root_logins ;; 
          7)  produce_report_all  ;;
          
          # Exit script on 'q'    
          r)  break ;; 

          # Handle invalid input
          *)  echo "Invalid input. Please try again." ;;
        esac
        
        # Pause until 'q' is pressed
        read -r -n 1 -p "
Press 'q' to continue or any other key to quit: " continue_key

        echo ""

        if [ "$continue_key" != "q" ]; then
            break
            clear
        fi
        clear 
      done
    ;;
    2)
      while true; do
        display_user
        
        read -r -n 1 -p "

Choose the report to user modification in the server : " selections

        clear

        case "$selections" in
          1)  add_user ;;
          2)  disable_user ;;
          3)  delete_user ;;  
          
          # Exit script on 'q'
          r)  break ;; 

          # Handle invalid input
          *)  echo "Invalid input. Please try again." ;;
        esac
        clear
      done
    ;;
    3) 
      service_restart
      read -r -n 1 -p "
Press 'q' to continue or any other key to quit: " continue_key

      echo ""
    ;;

    # Exit script on 'q'
    q)  break ;;
  esac
  clear
done

# Script termination message
echo "Script execution successful!"