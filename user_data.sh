#!/bin/bash
source /opt/env_server_port
echo "Hello, World" > index.html
sudo apt update
sudo apt install stress
nohup busybox httpd -h / -f -p $server_port &