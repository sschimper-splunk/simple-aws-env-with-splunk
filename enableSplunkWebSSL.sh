#!/bin/bash

# Wait for the Splunk instance 
# to be properly set up
sleep 10m

echo "stopped sleeping"

# enable web-ssl
sudo /opt/splunk/bin/splunk enable web-ssl

# check if Splunk web config file exists
# if not, create it
SERVER_CONFIG_FILE=/opt/splunk/etc/system/local/server.conf
if ![ -f "$SERVER_CONFIG_FILE" ]; then
    # touch "$SSL_CONFIG_FILE"
    echo "server.conf not found."
fi

if grep -q [sslConfig] "$SERVER_CONFIG_FILE";
then
  echo "[sslConfig] found!"
else
  cat <<EOT >> $SSL_CONFIG_FILE
   [sslConfig]
   sslVerifyServerName = true # turns on TLS certificate host name validation > server.conf
EOT
fi

# restart Splunk
sudo /opt/splunk/bin/splunk restart