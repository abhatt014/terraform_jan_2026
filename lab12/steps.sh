#!/bin/bash
# Install httpd
sudo dnf install -y httpd
# Start and enable httpd
sudo systemctl enable --now httpd
# Create a custom HTML page
echo "<h1>This is a development server!</h1>" > /var/www/html/index.html