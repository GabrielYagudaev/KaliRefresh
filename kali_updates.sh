#!/bin/bash

clear

# Function to display rainbow-colored text
function display_rainbow_text {
    text="$1"
    bold=$(tput bold)
    normal=$(tput sgr0)
    colors=("91" "93" "92" "96" "94" "95" "90" "97" "36" "31") # Define an array of ANSI color codes
    num_colors=${#colors[@]}
    for ((i=0; i<${#text}; i++)); do
        color_index=$((RANDOM % num_colors))
        color_code="${colors[$color_index]}"
        echo -e "${bold}\033[0;${color_code}m${text:i:1}${normal}\c" # Display each character of the text in a random color
        sleep 0.1
    done
    echo ""
}

# Function to display ASCII art welcome message
function display_ascii_art {
    echo -e "\e[1m\e[97m"
    cat << "EOF"
 ___________________________________________________________________
/\                                                                  \
\_|         _  __     _ _ ____       __               _             |
  |        | |/ /__ _| (_)  _ \ ___ / _|_ __ ___  ___| |__          |
  |        | ' // _` | | | |_) / _ \ |_| '__/ _ \/ __| '_ \         |
  |        | . \ (_| | | |  _ <  __/  _| | |  __/\__ \ | | |        |
  |        |_|\_\__,_|_|_|_| \_\___|_| |_|  \___||___/_| |_|        |
  |                                                                 |
  |   ______________________________________________________________|_
   \_/________________________________________________________________/

EOF
    echo -e "\e[0m"
}

# Display ASCII art welcome message
display_ascii_art

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Emojis
CHECK_MARK="✅"
WARNING="⚠"
REBOOT="🔄"

# Function to display step information
function display_step_info {
    echo -e "${YELLOW}$1${NC}" # Display step information in yellow
    sleep 1
}

# Function to display welcome message with date and time
function display_welcome_message {
    current_date=$(date +"%d/%m/%y")
    current_time=$(date +"%H:%M")

    echo -e "${CYAN}Script by Gabriel Yagudaev!${NC}"
    echo -e "${CYAN}Date: ${current_date} | Time: ${current_time}${NC}"
}

# Function to display system information with different colors for each section
function display_system_info {
    echo -e "${CYAN}[*] System Information:${NC}" # Display system information header in cyan
    echo -e "${CYAN}-------------------${NC}"

    # Kernel Version
    echo -e "${GREEN}[*] Kernel Version:${NC}" # Display kernel version in green
    uname -a
    echo ""

    # Operating System
    echo -e "${GREEN}[*] Operating System:${NC}" # Display operating system information in green
    lsb_release -a 2>/dev/null || cat /etc/os-release 2>/dev/null || cat /etc/issue 2>/dev/null
    echo ""

    # Filesystem Usage
    echo -e "${GREEN}[*] Filesystem Usage:${NC}" # Display filesystem usage in green
    df -h
    echo ""

    # Memory Usage
    echo -e "${GREEN}[*] Memory Usage:${NC}" # Display memory usage in green
    free -h
    echo ""

    # System Uptime
    echo -e "${GREEN}[*] System Uptime:${NC}" # Display system uptime in green
    uptime
    echo -e "${CYAN}-------------------${NC}"
}

# Function to perform full backup
function perform_full_backup {
    backup_dir="backup_$(date +'%Y%m%d_%H%M%S')"
    mkdir "$backup_dir"
    echo -e "${YELLOW}[*] Performing full backup...${NC}"
    sudo cp -r /etc/postgresql "$backup_dir"
    sudo cp -r /var/lib/postgresql "$backup_dir"
    echo -e "${GREEN}${CHECK_MARK} Full backup completed.${NC}"
    echo -e "${YELLOW}[*] Backup directory: ${backup_dir}${NC}"
}

# Display welcome message
display_welcome_message

# Display information about updates
echo
echo -e "${YELLOW}[*] This script will perform the following tasks:${NC}"
echo -e "${YELLOW}[*] 1. Purge PostgreSQL databases (optional)"
echo -e "${YELLOW}[*] 2. Update and upgrade system packages"
echo -e "${YELLOW}[*] 3. Perform cleanup with autoremove and autoclean"
echo -e "${YELLOW}[*] 4. Reboot the system${NC}"

sleep 1.5

# Display system information
read -p "[*] Do you want to display system information? (yes/no): " show_info_response
if [ "$show_info_response" == "yes" ]; then
    display_system_info
fi

# Display information about updates
echo -e "${YELLOW}[*] This script will purge PostgreSQL (if chosen), update and upgrade packages, perform autoremove and autoclean, and then reboot the system.${NC}"

# Ask the user if they want to continue
read -p "[*] Do you want to continue? (yes/no): " user_response

if [ "$user_response" == "yes" ]; then
    # Ask the user if they want to remove PostgreSQL databases
    read -p "[*] Do you want to remove PostgreSQL databases? (yes/no): " db_remove_response
    if [ "$db_remove_response" == "yes" ]; then
        perform_full_backup
        # Step 1: Purge PostgreSQL
        display_step_info "[*] Step 1: Purging PostgreSQL ${WARNING}"
        sudo apt purge -y postgresql*
        echo -e "${GREEN}${CHECK_MARK} PostgreSQL purged${NC}"
    else
        echo -e "${YELLOW}[*] Skipping PostgreSQL database removal.${NC}"
    fi

    # Step 2: Update and upgrade packages
    display_step_info "[*] Step 2: Updating and upgrading packages ${WARNING}"
    sudo apt update -y
    sudo apt upgrade -y
    echo -e "${GREEN}${CHECK_MARK} Packages updated and upgraded${NC}"

    # Step 3: Autoremove and autoclean
    display_step_info "[*] Step 3: Autoremove and autoclean ${WARNING}"
    sudo apt autoremove -y
    sudo apt autoclean -y
    echo -e "${GREEN}${CHECK_MARK} Autoremove and autoclean completed${NC}"

    # Step 4: Reboot
    display_step_info "[*] Step 4: Rebooting in 3 seconds... ${REBOOT}"
    sleep 3
    sudo reboot
else
    echo -e "${RED}[*] Operation aborted. Goodbye and thanks!${NC}"
fi
