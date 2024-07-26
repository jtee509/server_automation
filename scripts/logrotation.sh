#!/bin/bash

log_rotation() {
    services=(
    "apache2"
    "mysql"
    "httpd"
    "ssh"
    "nginx"
    "mariadb"
    )

    logrotate_cmd="logrotate -s /var/log/logrotate.status"
    logrotate_config="/etc/logrotate.d/services_logrotate"

    # Display services for user selection
    echo "
++------------------------Available services for log rotation------------------------++
"
    for i in "${!services[@]}"; do
    echo "$((i+1)). ${services[i]}"
    done

echo "
++-----------------------------------------------------------------------------------++
"

    echo "Enter numbers (comma-separated) for the services you want to rotate (or 'all'):"
    read selected_services

    # Process the user selection
    if [[ $selected_services == "all" ]]; then
    services_to_rotate=("${services[@]}")
    else
    services_to_rotate=()
    for num in $(echo $selected_services | tr ',' ' '); do
        if [[ $num -ge 1 && $num -le ${#services[@]} ]]; then
        services_to_rotate+=("${services[num-1]}")
        else
        echo "Invalid service number: $num. Skipping..."
        fi
    done
    fi

# Create the Logrotate Configuration
cat <<EOF > $logrotate_config
    # Log Rotation for Services
    $(for service in ${services[@]}; do
      log_dir="/var/log/$service"
      echo "/var/log/$service/*.log {" 
      echo "  daily"
      echo "  rotate 14"
      echo "  compress"
      echo "  delaycompress"
      echo "  missingok"
      echo "  notifempty"
      echo "  create 640 root adm"
      echo "}"
    done)
EOF


    # Run logrotate
    $logrotate_cmd $logrotate_config

    # Additional actions (optional)
    for service in ${services_to_rotate[@]}; do
    # Example: Restart service if log rotation is supported
    if command -v "$service" >/dev/null 2>&1; then
        echo "Restarting $service"
        service $service restart
    fi
    done

    echo "The log rotation is at /var/log/logrotate.status "
}
