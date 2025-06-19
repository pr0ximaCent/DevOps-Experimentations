#!/bin/bash
set -e

# Create a custom bridge network
echo "Creating a bridge network..."
ip link add name br0 type bridge
ip link set br0 up

# Create a namespace
echo "Creating a custom namespace..."
ip netns add custom_ns

# Create veth pairs and link them
echo "Setting up veth pair..."
ip link add veth0 type veth peer name veth1
ip link set veth1 netns custom_ns

# Assign IPs
echo "Assigning IP addresses..."
ip addr add 192.168.1.1/24 dev br0
ip link set veth0 master br0
ip link set veth0 up

ip netns exec custom_ns ip addr add 192.168.1.2/24 dev veth1
ip netns exec custom_ns ip link set veth1 up

# Set up default route
echo "Setting up default route..."
ip netns exec custom_ns ip route add default via 192.168.1.1

# Enable IP forwarding
echo "Enabling IP forwarding..."
sysctl -w net.ipv4.ip_forward=1 > /dev/null

# Add NAT for outgoing traffic
echo "Adding NAT rule for egress traffic..."
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 ! -o br0 -j MASQUERADE
sudo iptables --append FORWARD --in-interface br0 --jump ACCEPT
sudo iptables --append FORWARD --out-interface br0 --jump ACCEPT
echo "Network setup complete!"

