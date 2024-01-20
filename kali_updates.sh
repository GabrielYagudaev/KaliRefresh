#!/bin/bash

# Script by Gabriel Yagudaev

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Emojis
CHECK_MARK="✅"
WARNING="⚠️"
REBOOT="🔄"

clear 

# Function to display step information
function display_step_info {
    echo -e "${YELLOW}$1${NC}"
    sleep 1
}

# Function to display welcome message with date and time
function display_welcome_message {
    current_date=$(date +"%d/%m/%y")
    current_time=$(date +"%H:%M")

    echo -e "${CYAN}Update Script by Gabriel Yagudaev!${NC}"
    echo -e "${CYAN}Date: ${current_date} | Time: ${current_time}${NC}"
}

# Display welcome message
display_welcome_message

# Display information about updates
echo -e "${YELLOW}This script will purge PostgreSQL, update and upgrade packages, perform autoremove and autoclean, and then reboot the system.${NC}"

# Ask the user if they want to continue
read -p "Do you want to continue? (yes/no): " user_response

if [ "$user_response" == "yes" ]; then
    # Step 1: Purge PostgreSQL
    display_step_info "Step 1: Purging PostgreSQL ${WARNING}"
    sudo apt purge -y postgresql*
    echo -e "${GREEN}${CHECK_MARK} PostgreSQL purged${NC}"

    # Step 2: Update and upgrade packages
    display_step_info "Step 2: Updating and upgrading packages ${WARNING}"
    sudo apt update -y
    sudo apt upgrade -y
    echo -e "${GREEN}${CHECK_MARK} Packages updated and upgraded${NC}"

    # Step 3: Autoremove and autoclean
    display_step_info "Step 3: Autoremove and autoclean ${WARNING}"
    sudo apt autoremove -y
    sudo apt autoclean -y
    echo -e "${GREEN}${CHECK_MARK} Autoremove and autoclean completed${NC}"

    # Step 4: Reboot
    display_step_info "Step 4: Rebooting in 3 seconds... ${REBOOT}"
    sleep 3
    sudo reboot
else
    echo -e "${RED}Operation aborted. Goodbye and thanks!${NC}"
fi
