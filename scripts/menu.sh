#!/bin/bash

menu=(
  "System Health Report"
  "User Modification"
  "Service Restart"
  "Quit"
)

display_menu(){
    echo "
++----------------------------Action Menu----------------------------++

  "
  i=0
  for item in "${menu[@]}"; do
    if [[ $i -lt $(( ${#menu[@]} - 1 )) ]]; then  # Check if not the last item
        echo "$(($i + 1)). $item"
        let i++
    else  # Last item, don't number and add 'q'
        echo "q. $item"  
    fi
  done

  echo "
++------------------------------------------------------------------++

  " 
}

system=(
  "Check service status"
  "Analyze disk usage"
  "Monitor High CPU usage"
  "Identify long-running processes"
  "Memory Usage Live"
  "Display Root Logins From Last 7 Days"
  "Display All of the above"
  "Return to main menu"
)

display_report(){
    echo "
++---------------------System Reporting Menu---------------------++

  "
  i=0
  for item in "${system[@]}"; do
    if [[ $i -lt $(( ${#system[@]} - 1 )) ]]; then  # Check if not the last item
        echo "$(($i + 1)). $item"
        let i++
    else  # Last item, don't number and add 'q'
        echo "r. $item"  
    fi
  done 

      echo "
++---------------------------------------------------------------++

  "
}

user=(
  "Add New User"
  "Disable User"
  "Delete User"
  "Modify User"
  "Return to main menu"
)

display_user(){
    echo "
++---------------------User Maintainance Menu---------------------++

  "
  i=0
  # Loop through each item in the menu array
  for item in "${user[@]}"; do
    if [[ $i -lt $(( ${#user[@]} - 1 )) ]]; then  # Check if not the last item
        echo "$(($i + 1)). $item"
        let i++
    else  # Last item, don't number and add 'q'
        echo "r. $item"  
    fi
  done   

      echo "
++----------------------------------------------------------------++

  "
}

