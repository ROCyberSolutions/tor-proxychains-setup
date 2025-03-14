#!/bin/bash

# Script: setup_anonymous.sh
# Purpose: Automate the installation and configuration of Tor & ProxyChains for anonymous browsing and pentesting.
# The script configures your system to use Tor and ProxyChains for a high level of privacy and anonymity when browsing or performing penetration testing.

LOGFILE="tor_proxychains_setup.log"

# Function to log and display messages with color
log() {
    echo -e "[*] $1"
    echo "$(date) - $1" >> "$LOGFILE"
}

# Function for colored output
colorize() {
    case $1 in
        success) echo -e "\e[32m$2\e[0m" ;;  # Green for success
        error)   echo -e "\e[31m$2\e[0m" ;;  # Red for errors
        info)    echo -e "\e[34m$2\e[0m" ;;  # Blue for info
        warning) echo -e "\e[33m$2\e[0m" ;;  # Yellow for warnings
        *)       echo "$2" ;;  # Default color
    esac
}

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   log "This script must be run as root. Use: sudo ./setup_anonymous.sh"
   exit 1
fi

clear
# Display logo and contact info
colorize info "========================================="
colorize info "  ███▀███   ▒█████   ▄████▄    ██████ "
colorize info "  ▓██ ░ ██▒▒██▒  ██▒▒██▀ ▀█  ▒██    ▒ "
colorize info "  ▓██ ░▄█ ▒▒██░  ██▒▒▓█    ▄ ░ ▓██▄   "
colorize info "  ▒██▀▀█▄  ▒██   ██░▒▓▓▄ ▄██▒  ▒   ██▒"
colorize info "  ░██▓ ▒██▒░ ████▓▒░▒ ▓███▀ ░▒██████▒▒"
colorize info "  ░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░ ░▒ ▒  ░▒ ▒▓▒ ▒ ░"
colorize info "    ░▒ ░ ▒░  ░ ▒ ▒░   ░  ▒   ░ ░▒  ░ ░"
colorize info "    ░░   ░ ░ ░ ░ ▒  ░        ░  ░  ░  "
colorize info "     ░         ░ ░  ░ ░            ░  "
colorize info "                    ░                  "
colorize info "========================================="
colorize info "     https://rocybersolutions.com"
colorize info "     email: contact@rocybersolutions.com"
colorize info "========================================="

log "Starting setup..."

# Function to update and install packages
update_and_install() {
    log "Updating system and installing Tor & ProxyChains..."
    apt update -y && apt upgrade -y
    apt install tor proxychains -y
}

# Function to backup ProxyChains configuration
backup_proxychains() {
    log "Backing up original ProxyChains configuration..."
    cp /etc/proxychains4.conf /etc/proxychains4.conf.bak
}

# Function to configure ProxyChains
configure_proxychains() {
    log "Configuring ProxyChains..."
    # Enable dynamic chaining mode (to route through multiple proxies)
    sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains4.conf
    # Disable strict chain (prevents routing through multiple proxies if one fails)
    sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains4.conf
    # Disable random chain (to prevent random proxy selection)
    sed -i 's/^random_chain/#random_chain/' /etc/proxychains4.conf
    # Enable DNS over proxy to prevent DNS leaks
    sed -i 's/^#proxy_dns/proxy_dns/' /etc/proxychains4.conf

    # Ensure SOCKS5 proxy is added for Tor (to route all traffic through Tor network)
    if ! grep -q "socks5  127.0.0.1 9050" /etc/proxychains4.conf; then
        echo -e "\nsocks5  127.0.0.1 9050" >> /etc/proxychains4.conf
        log "Added SOCKS5 proxy to ProxyChains (Tor is listening on 127.0.0.1:9050)."
    else
        log "SOCKS5 proxy is already configured."
    fi
}

# Function to enable and start Tor service
start_tor_service() {
    log "Configuring and starting Tor service..."
    systemctl enable tor
    systemctl start tor

    # Verify Tor service status
    TOR_STATUS=$(systemctl is-active tor)
    if [[ "$TOR_STATUS" == "active" ]]; then
        log "Tor service is running successfully."
    else
        log "Tor service failed to start. Check manually using: sudo systemctl status tor"
        exit 1
    fi
}

# Function to test ProxyChains connectivity
test_proxychains() {
    log "Testing ProxyChains connection..."
    PROXY_TEST=$(proxychains curl -s https://check.torproject.org | grep -i "Congratulations")

    if [[ -n "$PROXY_TEST" ]]; then
        colorize success "✅ ProxyChains is working! You are anonymous."
        log "ProxyChains is successfully routing traffic through Tor. You are now using the Tor network."
    else
        colorize warning "⚠️ ProxyChains setup may have issues. Test manually with: proxychains curl https://check.torproject.org"
        log "ProxyChains did not route traffic through Tor. Possible issues with configuration."
    fi
}

# Run all functions
update_and_install
backup_proxychains
configure_proxychains
start_tor_service
test_proxychains

# Display final instructions and anonymity explanation
colorize info "========================================="
colorize success "✅ Setup Complete! You can now use ProxyChains."
colorize info "========================================="
colorize info "🔥 Commands to test:"
colorize info "   🔹 Browsing: proxychains firefox www.dnsleaktest.com"
colorize info "   🔹 Scanning: proxychains nmap -sT -Pn target.com"
colorize info "   🔹 Exploiting: proxychains sqlmap -u http://www.target.com/product?id=3"
colorize info "========================================="
colorize info "🛡️ Anonymity Information:"
colorize info "   - Tor (The Onion Router) routes your internet traffic through a volunteer-run network of nodes, "
colorize info "     providing anonymity by obscuring the origin of your traffic."
colorize info "   - ProxyChains routes your traffic through Tor (or other proxies) in a 'dynamic_chain' manner, "
colorize info "     meaning traffic can pass through multiple proxies to make it harder to trace."
colorize info "   - Proxy DNS ensures that DNS queries are also routed through Tor, preventing DNS leaks."
colorize info "   - The expected detection level when using Tor is low, but your activity may still be detected via:"
colorize info "     - Exit node monitoring (since your traffic exits the Tor network at a random node)"
colorize info "     - Timing analysis (if you're interacting with services that correlate activity)"
colorize info "     - Browser fingerprinting (if you're not using privacy-focused browsers)"
colorize info "     - Some websites may block Tor traffic (check with a service like www.dnsleaktest.com)"
colorize info "========================================="
log "Setup completed successfully!"
exit 0
