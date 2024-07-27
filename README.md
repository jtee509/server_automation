# server_automation
# Server Automation

This Python-based utility generates comprehensive system reports and offers basic service management functionality.

## Features

* **System Reports:**
    * CPU Utilization
    * Memory Usage
    * Disk Space Analysis
    * Root Log Records (Recent entries)
    * Long-Running Processes
    * Systemctl Service Statuses
* **Service Management:**
    * Restart systemctl services (when in a failed state)

## Installation

1. **Prerequisites:**
    * Python 3.x
    * `bash` shell (for the main script)

    To install python: 

    * For Debian/Ubuntu
    ```bash
    sudo apt-get install python3.8
    ``` 
    * For Arch Linux
    ```bash
    sudo pacman -S python3.8
    ```     
    * For Rocky Linux
    ```bash
    sudo dnf install python3.8
    ``` 

2. **Install Python Packages:**
    ```bash
    pip install psutil  # For system resource monitoring
    ``` 

3. **Grant Execution Permission:**
    ```bash
    chmod +x main.sh 
    ```

## Usage

Run the main script:

```bash
./main.sh
```