#! /bin/bash

analyze_disk_usage() {
  echo "
  ++---------------------Disk Usage Report---------------------++
  
  "
  df -h

  echo "
  
  ++-----------------------------------------------------------++

  "
}

# Method to monitor CPU usage if it goes over 75%
monitor_cpu_usage() {
  
  echo "
  ++---------------------CPU Usage Report---------------------++
  
  "

  cpu_usage=$(ps aux | awk '{sum += $3}; END {print sum}')  # ps aux for CPU usage
  cpu_usage=${cpu_usage%.*}  # Remove decimal places for integer comparison

  echo "CPU USAGE: $cpu_usage%"

  cpu_threshold=200

  if [[ -n "$cpu_usage" && "$cpu_usage" =~ ^[0-9]+$ ]]; then
    if [ "$cpu_usage" -gt "$cpu_threshold" ]; then
      echo "WARNING! HIGH CPU USAGE DETECTED!"
    fi

  else
    echo "Error: Unable to determine CPU usage."
  fi


  echo "
  
  ++-----------------------------------------------------------++

  "

}

# Method to identify processes running longer than an hour
identify_long_running_processes() {
  echo "
  ++---------------------Long Running Processes Report---------------------++
  
  "

  # Get the current time in seconds since epoch
  current_time=$(date +%s)

  # Calculate the threshold time (one hour ago)
  process_threshold=$((current_time - 3600))

  # Filter processes running longer than threshold using awk
  long_running_processes=$(ps -eo pid,etime,cmd --sort=start_time | awk -v threshold="$process_threshold" '$2 > threshold { print $0 }')

  # Check if any long running processes were found
  if [ -n "$long_running_processes" ]; then
    echo "Processes running longer than an hour:"
    echo "$long_running_processes"
  else
    echo "No processes running longer than an hour have been found."
  fi

  echo "
  ++---------------------------------------------------------------------++
  
  "
  
}

# Script that output memory status for the program

memory_usage_report (){
  
  echo "
  ++---------------------Memory Usage Report---------------------++
  
  "

  python3 scripts/memory_usage.py

  echo "
  
  ++-------------------------------------------------------------++

  "
}

display_root_logins() {
  echo "
  ++---------------Root Logs Within (7 Days) Report---------------++
  "

  # Check for root privileges more concisely
  if ! [ $(id -u) = 0 ]; then
    echo "Error: This script requires root privileges (use sudo)." 1>&2  # Use stderr for errors
    exit 1
  fi

  date_seven_days_ago=$(date +%Y-%m-%d --date="7 days ago")

  # Use journalctl with _COMM filter for sudo commands
  login_entries=$(sudo journalctl _COMM=sudo --since="$date_seven_days_ago" | awk '{print $1" "$2" "$3" "$8}')

  if [ -n "$login_entries" ]; then
    echo "Users who logged in as root (sudo) in the past 7 days:"
    echo "-----------------------------------------------------"
    echo "DATE      TIME         USER    COMMAND"
    echo "-----------------------------------------------------"
    echo "$login_entries" | sort # Sort for better readability
  else
    echo "No root (sudo) logins found within the last 7 days!"
  fi

  echo "
  ++--------------------------------------------------------------++
  "
}


# Script to generate a report of all system statuses
produce_report_all() {
  while true; do
    # Check service status and print results
    check_service_status "2"
    echo "=========================================================================="

    # Analyze disk usage and print results
    analyze_disk_usage
    echo "=========================================================================="

    # Monitor CPU usage and print results (including potential alert)
    monitor_cpu_usage
    echo "=========================================================================="

    # Identify long running processes and print results
    identify_long_running_processes
    echo "=========================================================================="

    # Script that output memory status for the program
    memory_usage_report
    echo "=========================================================================="

    # Script that output root login
    display_root_logins
    echo "=========================================================================="
    
    echo "Report Generated Succesfully!"
    echo "=========================================================================="
    
    clear
  done
}



