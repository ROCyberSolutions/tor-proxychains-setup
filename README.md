Certainly! Below is an improved version of the `README.md` file based on the script and instructions provided above:

---

# **Tor & ProxyChains Setup for Anonymity**

This script automates the installation and configuration of **Tor** and **ProxyChains** on a Linux system to ensure **anonymous browsing** and **penetration testing**.

It routes your internet traffic through the **Tor network** and uses **ProxyChains** to configure your applications to route their traffic through Tor, ensuring **maximum privacy**.

---

## **Overview**

- **Tor** (The Onion Router) is a privacy-focused network that anonymizes your internet traffic by routing it through a series of volunteer-run nodes.
- **ProxyChains** is a tool that forces applications to route their traffic through a proxy, in this case, Tor. This ensures that any application you use (e.g., browsers, curl, nmap) will route its traffic anonymously.

### **What This Script Does:**

- Installs and configures **Tor** and **ProxyChains**.
- Configures **ProxyChains** to use Tor as the proxy.
- Starts the **Tor service** and sets it to run on system boot.
- Verifies that ProxyChains routes traffic through the Tor network.
- Adds important **privacy enhancements** to prevent DNS leaks.

---

## **Installation**

1. **Clone this repository or download the script:**

   ```bash
   git clone https://github.com/your-username/tor-proxychains-setup.git
   cd tor-proxychains-setup
   ```

2. **Run the setup script as root:**

   ```bash
   sudo ./setup_anonymous.sh
   ```

   - The script will install **Tor** and **ProxyChains**.
   - It will configure **ProxyChains** to route traffic through **Tor**.
   - It will start the **Tor service** and enable it to run on boot.

---

## **Usage**

### **Testing Your Setup:**

Once the setup is complete, you can test that **ProxyChains** is working correctly by running the following command:

```bash
proxychains curl -s https://check.torproject.org
```

- If everything is set up correctly, you should see a message saying: **"Congratulations. This browser is configured to use Tor."**
- If the setup is not working as expected, you can troubleshoot by running:  
   ```bash
   proxychains curl -v https://check.torproject.org
   ```
   This will show detailed logs to help diagnose any issues.

---

### **How to Use ProxyChains with Your Applications:**

You can use **ProxyChains** to route your traffic through Tor with any application by simply prepending `proxychains` to the command.

For example:
- **Browsing**:  
   ```bash
   proxychains firefox www.dnsleaktest.com
   ```
- **Penetration Testing**:  
   ```bash
   proxychains nmap -sT -Pn target.com
   ```
- **Web Exploiting**:  
   ```bash
   proxychains sqlmap -u http://www.target.com/product?id=3
   ```

---

## **Anonymity Information**

### **Tor (The Onion Router):**

- Tor provides anonymity by routing your internet traffic through a network of volunteer-operated nodes.
- It uses **onion routing**, which means traffic is encrypted in layers, with each node decrypting only a part of the traffic to prevent tracking of the data source.
- **DNS requests** are also routed through the Tor network to avoid DNS leaks, ensuring that your browsing history is not visible.

### **ProxyChains:**

- **ProxyChains** forces any application to use a proxy (in this case, **Tor**). This ensures that all traffic from applications, even those that don't natively support proxies, are routed through Tor.
- ProxyChains is configured to use **dynamic chaining**, meaning traffic can pass through multiple proxies for enhanced privacy.

### **Detection Level:**

- **Tor** provides a **low detection** rate, but it’s not entirely untraceable.
- **Exit Node Monitoring**: Traffic can be monitored at the exit node of the Tor network, where it exits onto the open internet.
- **Timing Analysis**: An adversary with enough resources can attempt to correlate the time patterns of your traffic with specific events.
- **Browser Fingerprinting**: Websites can attempt to track your activity via **browser fingerprinting** even when using Tor.
- **Blocked Tor Traffic**: Some websites actively block or restrict traffic from **Tor exit nodes**.

To mitigate detection, it’s recommended to use **privacy-focused browsers** (e.g., Tor Browser) and to ensure your traffic doesn’t exhibit patterns that can be correlated.

---

## **Log File**

The script logs its output to a file named `tor_proxychains_setup.log`. This log includes the status of the installation and configuration process, along with any errors or issues encountered.

---

## **Troubleshooting**

If you encounter issues during the setup or while using **ProxyChains**, here are a few things you can check:

1. **Tor Service Not Starting:**

   - Verify Tor service status with:
     ```bash
     systemctl status tor
     ```
   - If Tor is not running, try restarting it:
     ```bash
     systemctl restart tor
     ```

2. **ProxyChains Not Working:**

   - Run the command with **verbose output**:
     ```bash
     proxychains curl -v https://check.torproject.org
     ```
   - This will give more details on why it might be failing.

---

## **Credits and License**

This script is provided under the MIT license. Feel free to fork, modify, and contribute.

**Credits**:
- [Tor Project](https://www.torproject.org/) for providing the Tor network.
- [ProxyChains](https://github.com/rofl0r/proxychains-ng) for providing ProxyChains functionality.

**License**:  
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## **Contact**

For any issues or suggestions, feel free to contact us via:

- **Email**: [contact@rocybersolutions.com](mailto:contact@rocybersolutions.com)
- **Website**: [rocybersolutions.com](https://rocybersolutions.com)

---
