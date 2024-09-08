import psutil
import socket  # Import the socket module for AF_INET
# this will work on windows
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




# this will work on the mac
def get_local_ip():
    # Connect to a remote host (doesn't matter if it's reachable)
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.connect(("8.8.8.8", 80))  # Google's DNS
    local_ip = sock.getsockname()[0]
    sock.close()
    return local_ip

# Get the local IP and update the .tfvars file
local_ip = get_local_ip()
print(local_ip)