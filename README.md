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
    sudo apt-get install python3.12 python3-psutil
    ``` 
    * For Arch Linux
    ```bash
    sudo pacman -S python3.12 python3-psutil
    ```     
    * For Rocky Linux
    ```bash
    sudo dnf install python3.12 python3-psutil
    ``` 

2. **Grant Execution Permission:**
    ```bash
    sudo chmod +x main.sh 
    ```

## Usage
There are 2 ways to run it

Run the main script (without root functions):

```bash
./main.sh
```

Run the main script (with root functions):

```bash
sudo ./main.sh
```