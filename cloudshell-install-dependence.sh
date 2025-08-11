#!/bin/bash

# A script to install Go, Terraform, and Packer on Debian/Ubuntu or RHEL/CentOS/Fedora.
# It must be run with sudo or as the root user.

# Exit immediately if a command exits with a non-zero status.
set -e

#################################
#         VARIABLES             #
#################################

# Set the Go version to install. Find latest versions at https://go.dev/dl/
GO_VERSION="1.22.5"

# Auto-detect architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64) GO_ARCH="amd64" ;;
    aarch64) GO_ARCH="arm64" ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac


#################################
#      HELPER FUNCTIONS         #
#################################

# Function to print informational messages
print_info() {
    echo -e "\n\e[34m[INFO]\e[0m $1"
}

# Function to print success messages
print_success() {
    echo -e "\e[32m[SUCCESS]\e[0m $1"
}


#################################
#       MAIN FUNCTIONS          #
#################################

# 1. Check for root/sudo privileges
check_privileges() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "Error: This script must be run with sudo or as the root user."
        exit 1
    fi
}

# 2. Install common dependencies
install_dependencies() {
    print_info "Updating package list and installing dependencies..."
    if command -v apt-get &>/dev/null; then
        apt-get update
        apt-get install -y wget gpg software-properties-common unzip
    elif command -v dnf &>/dev/null; then
        dnf install -y wget gpg dnf-plugins-core unzip
    elif command -v yum &>/dev/null; then
        yum install -y wget gpg yum-utils unzip
    else
        echo "Error: Unsupported package manager. Cannot install dependencies."
        exit 1
    fi
}

# 3. Install Go
install_go() {
    print_info "Installing Go v${GO_VERSION}..."
    # Download and extract Go binary
    wget "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" -O /tmp/go.tar.gz
    # Remove any previous Go installation
    rm -rf /usr/local/go
    tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz

    # Configure the PATH environment variable for all users
    print_info "Configuring system-wide Go path in /etc/profile.d/go.sh"
    echo 'export PATH=$PATH:/usr/local/go/bin' > /etc/profile.d/go.sh
    echo 'export GOPATH=$HOME/go' >> /etc/profile.d/go.sh

    # Source the file to make 'go' command available in this session
    source /etc/profile.d/go.sh
    print_success "Go v${GO_VERSION} installed."
}

# 4. Install HashiCorp tools (Terraform & Packer)
install_hashicorp_tools() {
    print_info "Installing Terraform and Packer..."
    # Use the appropriate package manager
    if command -v apt-get &>/dev/null; then
        # Add HashiCorp GPG key
        wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
        # Add the official HashiCorp repository
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list
        # Update and install
        apt-get update
        apt-get install -y terraform packer
    elif command -v dnf &>/dev/null || command -v yum &>/dev/null; then
        # Add the official HashiCorp repository
        if command -v dnf &>/dev/null; then
            dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
            dnf install -y terraform packer
        else
            yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
            yum install -y terraform packer
        fi
    else
        echo "Error: Could not find apt, dnf, or yum. Cannot install HashiCorp tools."
        exit 1
    fi
    print_success "Terraform and Packer installed."
}

# 5. Verify the installations
verify_installation() {
    print_info "Verifying installations..."
    
    # Export Go path for verification check
    export PATH=$PATH:/usr/local/go/bin

    go version
    packer --version
    terraform --version

    echo
    print_success "All tools have been installed successfully! 🎉"
    print_info "You may need to log out and log back in for the Go environment variables to be available in your terminal."
}


#################################
#       SCRIPT EXECUTION        #
#################################

main() {
    check_privileges
    install_dependencies
    install_go
    install_hashicorp_tools
    verify_installation
}

main "$@"
