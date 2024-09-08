import psutil
import socket  # Import the socket module for AF_INET

def get_non_virtual_ip():
    # Loop over all network interfaces
    for interface_name, interface_addresses in psutil.net_if_addrs().items():
        # Skip virtual interfaces like "vEthernet" and Loopback interfaces
        if "vEthernet" in interface_name or "Loopback" in interface_name:
            continue
        
        for address in interface_addresses:
            print(address)
            # Use socket.AF_INET to check for IPv4 addresses
            if address.family == socket.AF_INET:
                return address.address

non_virtual_ip = get_non_virtual_ip()
print(f"The IP address of the first non-virtual network interface is: {non_virtual_ip}")
