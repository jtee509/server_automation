#!/bin/bash

services=(
    "apache2" 
    "mysql"
    "httpd"
    "ssh"
    "nginx"
    "mariadb"
  )

check_service_status() {
  while true; do

    local choice="$1" 

    if [ -z "$choice" ]; then
      echo "    
Choose an option:
  1. Check specific service status
  2. Check all services status
  q. return to main menu
  
  "
      read -r -n 1 -p "Enter your choice: " choice
    fi 
    clear

    case $choice in
      1)
        while true; do
          echo "Available services:"
          for i in "${!services[@]}"; do
              echo "$((i + 1)). ${services[$i]}"
          done

          read -r -n 1 -p "Enter service number to check (0 to exit): " service_num

          clear

          if ((service_num == 0)); then
              break # Exit the loop if the user enters 0
          elif [[ "$service_num" == "all" ]]; then 
            choice=2
            break
          elif ((service_num >= 1 && service_num <= ${#services[@]})); then
            service_name=${services[$((service_num - 1))]}
            status=$(systemctl is-active "$service_name")
            echo "
++---------------------System Services Report ---------------------++

    "

            echo "
  $service_name status: $status

  "

            echo "
    
++-----------------------------------------------------------------++

    "
          else
              echo "Invalid service number."
          fi
        done
        ;;

      #Printing all service status
      2)
        echo "
++---------------------System Services Report ---------------------++

    "
        echo "Checking status of all services:"
        for service_name in "${services[@]}"; do
          status=$(systemctl is-active "$service_name")
          echo "$service_name status: $status"
        done
        echo "
    
++-----------------------------------------------------------------++

    "
                # Pause until 'q' is pressed
        read -r -n 1 -p "Press 'q' to continue or any other key to quit: " continue_key
        if [ "$continue_key" != "q" ]; then
            break
            clear
        fi

        ;;

      #Enter 'q' to quit 
      q) break;;


      *)
        echo "Invalid choice."
        ;;
    esac
  done 
}


# Function to check if a service exists
service_exists() {
  systemctl is-active --quiet "$1"
}

service_restart()(
  for service in "${services[@]}"; do
    if service_exists "$service"; then
      echo "Restarting $service..."
      sudo systemctl restart "$service"
      if [ $? -eq 0 ]; then
        echo "$service restarted successfully."
      else
        echo "Error restarting $service."
      fi
    else
      echo "Service $service not found or not active."
    fi
  done
)
