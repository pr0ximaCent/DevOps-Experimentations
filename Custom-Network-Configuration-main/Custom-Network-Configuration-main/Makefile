# Makefile

.PHONY: all setup_network test_ping clean

all: setup_network test_ping

setup_network:
	@echo "Setting up the custom network..."
	bash scripts/setup_network.sh

test_ping:
	@echo "Testing network configuration..."
	bash scripts/test_ping.sh

clean:
	@echo "Cleaning up network configuration..."
	ip netns delete custom_ns || true
	ip link delete veth0 || true
	ip link delete br0 || true

