#!/bin/bash

# If Splunk UF is not yet installed, download and install it
if [ ! -d "/opt/splunk" ]; then
    # Download Splunk Trial Version
    echo "Splunk not installed - Downloading and installing Splunk now"
    sudo wget -O splunk-9.0.3-dd0128b1f8cd-Linux-x86_64.tgz "https://download.splunk.com/products/splunk/releases/9.0.3/linux/splunk-9.0.3-dd0128b1f8cd-Linux-x86_64.tgz"

    # Move package and update env variable
    echo "Extracting Splunk package to /opt"
    sudo tar xzf splunk-9.0.3-dd0128b1f8cd-Linux-x86_64.tgz --directory /opt
    sudo rm splunk-9.0.3-dd0128b1f8cd-Linux-x86_64.tgz

    # Create Splunk user and group
    echo "Adding user called 'splunk' and user group"
    sudo useradd -m splunk
    sudo groupadd splunk
    sudo chown -R splunk:splunk /opt/splunk

    # Create self-signed certificate
    echo "Creating self-signed certificate"
    sudo mkdir /opt/splunk/etc/auth/custom
    sudo openssl genrsa -aes256 -passout pass:changeme -out /opt/splunk/etc/auth/custom/SplunkPrivateKey.key 2048
    sudo openssl req -new -key /opt/splunk/etc/auth/custom/SplunkPrivateKey.key -passin pass:changeme -out /opt/splunk/etc/auth/custom/Splunk.csr -subj "/C=CZ/ST=Bohemia/L=Praha/O=Splunk Community/CN=*"
    sudo openssl rsa -in /opt/splunk/etc/auth/custom/SplunkPrivateKey.key -passin pass:changeme -out /opt/splunk/etc/auth/custom/SplunkKey.key
    sudo openssl x509 -req -in /opt/splunk/etc/auth/custom/Splunk.csr -signkey /opt/splunk/etc/auth/custom/SplunkPrivateKey.key -passin pass:changeme -out /opt/splunk/etc/auth/custom/Splunk.pem -outform PEM

    # Change ownership of self-signed certificate to user 'splunk'
    sudo chown -R splunk:splunk /opt/splunk/etc/auth/custom/Splunk.pem
    sudo chown -R splunk:splunk /opt/splunk/etc/auth/custom/SplunkKey.key

    # Enable SSL Encryption
    sudo echo -e "[settings]\nenableSplunkWebSSL = true\nprivKeyPath = /opt/splunk/etc/auth/custom/SplunkKey.key\nserverCert = /opt/splunk/etc/auth/custom/Splunk.pem\n" > /opt/splunk/etc/system/local/web.conf

    # Start Splunk
    # by running the 'start' command as non-root user
    echo "Starting Splunk"
    sudo /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd changeme
fi