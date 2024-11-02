-#!/bin/bash

# Exit immediately if any command fails or if an unset variable is used
set -e ; set -u ; set -o pipefail

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# Create a log file if it doesn't exist
LOGFILE="./logfile"
if [[ ! -e $LOGFILE ]]; then
    touch "$LOGFILE"
else 
    echo "------------------New Execution----------------" >> "$LOGFILE"
fi

# Function to log messages
log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOGFILE"
}

# Function to handle errors
error_handler() {
    local error_message="$1"
    log_message "$error_message"
    exit 1
}

# Check if environment variables are set and not empty
validate_env_vars() {
    local vars=(DNS_SERVER NTP_SERVER USERNAME PASSWORD ROOT_PASSWORD)
    for var in "${vars[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            error_handler "Error: Environment variable '$var' is not set or is empty."
        fi
    done
}

# Function to check and create required files if missing
check_required_files() {
    local files=(./env /etc/apt/sources.list /etc/resolv.conf)
    for file in "${files[@]}"; do
        if [[ ! -f $file ]]; then
            log_message "File '$file' does not exist. Creating it."
            touch "$file" || error_handler "Failed to create file '$file'."
            log_message "Created missing file '$file'."
        fi
    done
}

# Function to install necessary packages
install_packages() {
    log_message "Updating package lists and installing required packages."
    apt update &>/dev/null || error_handler "Failed to update package lists."
    apt install -y openssl ufw chrony git &>/dev/null || error_handler "Failed to install packages."
    log_message "Packages updated and installed."
}


# Load environment variables from the file
if [[ -f ./env ]]; then
    source ./env || error_handler "Failed to load environment variables from './env'."
else
    error_handler "Environment file not found!"
fi

# Function to add Debian repositories
add_repos() {
    echo "" > /etc/apt/sources.list || error_handler "Failed to write to /etc/apt/sources.list."
    log_message "Adding Debian repositories."
    cat <<EOF >> /etc/apt/sources.list
deb [trusted=yes] http://debian.partdp.ir/ bookworm main contrib non-free non-free-firmware
deb [trusted=yes] http://debian.partdp.ir/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb [trusted=yes] http://debian.partdp.ir/ bookworm-updates main contrib non-free non-free-firmware
EOF
    apt update &>/dev/null || error_handler "Failed to update package lists after adding repositories."
    log_message "Debian repositories added."
}

# Function to add multi vars into an array
varsToArr(){
    local whereto=$3
    local addStr=$2
    IFS=',' read -ra ARRAY <<< "$1"
    for item in "${ARRAY[@]}"; do
        echo "$addStr $item" >> "$whereto" || error_handler "Failed to add '$addStr $item' to '$whereto'."
    done
}

# Function to add DNS IPs to resolv.conf
add_dns_servers() {
    log_message "Adding DNS servers."
    varsToArr "$DNS_SERVER" "nameserver" "/etc/resolv.conf"
    log_message "DNS servers added."
}

# Function to configure NTP servers
configure_ntp() {
    apt install chrony -y &>/dev/null || error_handler "Failed to install chrony."
    log_message "Setting up NTP servers."
    sed -i '/pool/d' /etc/chrony/chrony.conf || error_handler "Failed to modify /etc/chrony/chrony.conf."
    varsToArr "$NTP_SERVER" "pool" "/etc/chrony/chrony.conf"
    systemctl start chrony &>/dev/null || error_handler "Failed to start chrony service."
    systemctl enable chrony &>/dev/null || error_handler "Failed to enable chrony service."
}

# Function to create a new user
create_user() {
    if id "$USERNAME" &>/dev/null; then
        local message="Notice: User '$USERNAME' already exists. Skipping user creation."
        echo "$message" >&2
        log_message "$message"
        return 0
    fi
    log_message "Creating user '$USERNAME'."
    useradd -m "$USERNAME" || error_handler "Failed to create user '$USERNAME'."
    echo "$USERNAME:$PASSWORD" | /usr/sbin/chpasswd || error_handler "Failed to set password for $USERNAME."
    chage -M 30 "$USERNAME" || error_handler "Failed to set password expiration for user '$USERNAME'."
    EXPIRATION_DATE=$(date -d "+90 days" +"%Y-%m-%d")
    chage -E "$EXPIRATION_DATE" "$USERNAME" || error_handler "Failed to set account expiration for user '$USERNAME'."
    log_message "User $USERNAME created with password expiration set."
}

# Function to set password for root user
set_root_password() {
    log_message "Setting password for root."
    echo "root:$ROOT_PASSWORD" | /usr/sbin/chpasswd || error_handler "Failed to set root password."
    log_message "Root password set."
}

# Function to configure SSH
configure_ssh() {
    log_message "Configuring SSH."
    sed -i 's/^#*PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config || error_handler "Failed to configure PermitRootLogin."
    sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config || error_handler "Failed to configure PasswordAuthentication."
    sed -i 's/^#*PubkeyAuthentication .*/PubkeyAuthentication yes/' /etc/ssh/sshd_config || error_handler "Failed to configure PubkeyAuthentication."
    sed -i 's|^#*AuthorizedKeysFile .*|AuthorizedKeysFile .ssh/authorized_keys|' /etc/ssh/sshd_config || error_handler "Failed to configure AuthorizedKeysFile."
    systemctl restart ssh || error_handler "Failed to restart SSH service."
    log_message "SSH configuration updated and service restarted."
}

# Function to set up firewall
configure_firewall() {
    apt install ufw -y &>/dev/null || error_handler "Failed to install ufw."
    log_message "Setting up the firewall."
    ufw --force enable || error_handler "Failed to enable the firewall."
    ufw allow ssh || error_handler "Failed to allow SSH through the firewall."
    log_message "Firewall configured and SSH allowed."
}

# Display menu and prompt user
echo "Select an option:"
echo "1) Run entire script"
echo "2) Install packages"
echo "3) Add Debian repositories"
echo "4) Add DNS IPs"
echo "5) Configure NTP"
echo "6) Create user"
echo "7) Set root password"
echo "8) Configure SSH"
echo "9) Configure firewall"
echo "q) Quit"
read -p "Enter your choice (1-9, q): " choice

# Run validations
validate_env_vars
check_required_files

case $choice in
    1)
        # Run the entire script
        add_repos
        install_packages
        add_dns_servers
        configure_ntp
        create_user
        set_root_password
        configure_ssh
        configure_firewall
        log_message "Script execution completed successfully."
        ;;
    2) install_packages;;
    3) add_repos ;;
    4) add_dns_servers ;;
    5) configure_ntp ;;
    6) create_user ;;
    7) set_root_password ;;
    8) configure_ssh ;;
    9) configure_firewall ;;
    q)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting."
        log_message "Invalid menu choice selected by the user."
        exit 1
        ;;
esac
