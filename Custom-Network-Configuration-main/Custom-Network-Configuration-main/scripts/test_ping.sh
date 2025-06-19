#!/bin/bash
set -e

# Test pinging Google's nameserver from the custom namespace
echo "Testing egress networking by pinging 8.8.8.8..."
ip netns exec custom_ns ping -c 4 8.8.8.8
echo "Ping test successful!"

