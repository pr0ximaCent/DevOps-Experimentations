
# Custom Bridge Network with Egress Networking

This guide demonstrates how to set up a custom bridge network, configure network namespaces, enable egress traffic to an external network (e.g., Google's nameserver `8.8.8.8`), and ensure proper network isolation using `iptables` for NAT.



## Prerequisites

- Linux system with root privileges.
- Basic understanding of `ip`, `iptables`, and namespaces.
- Ensure `iproute2` and `iptables` are installed.



## Steps

### 1. Enable IP Forwarding

IP forwarding is required to route traffic from the namespace to external networks.

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

Make it persistent:

```bash
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

---

### 2. Create a Custom Bridge Network

Run the `create_bridge.sh` script to create the bridge and assign it an IP address.

```bash
#!/bin/bash
set -e

BRIDGE_NAME="br_custom"

# Check if the bridge already exists
if ip link show | grep -q "$BRIDGE_NAME"; then
    echo "Bridge '$BRIDGE_NAME' already exists. Skipping creation."
    exit 0
fi

# Create the bridge
sudo ip link add name "$BRIDGE_NAME" type bridge
sudo ip addr add 192.168.1.1/24 dev "$BRIDGE_NAME"
sudo ip link set "$BRIDGE_NAME" up

echo "Custom bridge '$BRIDGE_NAME' created with IP 192.168.1.1/24."
```

Run the script:

```bash
bash scripts/create_bridge.sh
```

---

### 3. Create and Configure a Namespace

Run the `setup_namespace.sh` script to create the namespace, attach it to the bridge, and configure networking.

```bash
#!/bin/bash
set -e

NAMESPACE="custom_ns"
VETH0="veth0"
VETH1="veth1"

# Check if the namespace already exists
if ip netns list | grep -q "$NAMESPACE"; then
    echo "Namespace '$NAMESPACE' already exists. Skipping creation."
    exit 0
fi

# Create the namespace
sudo ip netns add "$NAMESPACE"

# Create a veth pair
sudo ip link add "$VETH0" type veth peer name "$VETH1"

# Attach one end to the namespace
sudo ip link set "$VETH1" netns "$NAMESPACE"

# Attach the other end to the bridge
sudo ip link set "$VETH0" master br_custom
sudo ip link set "$VETH0" up

# Configure namespace network
sudo ip netns exec "$NAMESPACE" ip addr add 192.168.1.2/24 dev "$VETH1"
sudo ip netns exec "$NAMESPACE" ip link set "$VETH1" up
sudo ip netns exec "$NAMESPACE" ip route add default via 192.168.1.1

echo "Namespace '$NAMESPACE' configured with IP 192.168.1.2 and default gateway 192.168.1.1."
```

Run the script:

```bash
bash scripts/setup_namespace.sh
```

---

### 4. Configure NAT with iptables

Set up NAT to allow traffic from the namespace to access external networks.

```bash
sudo iptables -t nat -A POSTROUTING -s 192.168.1.0/24 ! -o br_custom -j MASQUERADE
```

Make the NAT rule persistent:

```bash
sudo apt-get install iptables-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload
```

---

### 5. Set Up DNS for the Namespace

Create a custom DNS configuration for the namespace to resolve domain names.

```bash
sudo mkdir -p /etc/netns/custom_ns
echo "nameserver 8.8.8.8" | sudo tee /etc/netns/custom_ns/resolv.conf
```

---

### 6. Test Connectivity

#### Ping External IP

Ping Google's nameserver `8.8.8.8` from the namespace:

```bash
sudo ip netns exec custom_ns ping -c 4 8.8.8.8
```

#### Test DNS Resolution

Ping a domain name (e.g., `google.com`) from the namespace:

```bash
sudo ip netns exec custom_ns ping -c 4 google.com
```

---

### 7. Clean Up

To clean up the resources, run the following commands:

```bash
sudo ip netns del custom_ns
sudo ip link del br_custom
sudo iptables -t nat -D POSTROUTING -s 192.168.1.0/24 ! -o br_custom -j MASQUERADE
```

---

### 8. Automate with Makefile

Use the following `Makefile` to automate the process:

```makefile
.PHONY: all create_network setup_namespace test_network clean

all: create_network setup_namespace test_network

create_network:
	bash scripts/create_bridge.sh

setup_namespace:
	bash scripts/setup_namespace.sh

test_network:
	sudo ip netns exec custom_ns ping -c 4 8.8.8.8
	sudo ip netns exec custom_ns ping -c 4 google.com

clean:
	sudo ip netns del custom_ns || true
	sudo ip link del br_custom || true
	sudo iptables -t nat -D POSTROUTING -s 192.168.1.0/24 ! -o br_custom -j MASQUERADE || true
```

Run the automation:

```bash
make
```

To clean up:

```bash
make clean
```
```
