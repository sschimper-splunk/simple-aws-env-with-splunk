#!/bin/bash

# check if Splunk web config file exists
# if not, create it
SSL_CONFIG_FILE=/opt/splunk/etc/system/local/web.conf
if ![ -f "$SSL_CONFIG_FILE" ]; then
    touch "$SSL_CONFIG_FILE"
fi

# write settings to file
cat <<EOT >> $SSL_CONFIG_FILE
[settings]
httpport = 8000
enableSplunkWebSSL = true
EOT

# restart Splunk
/opt/splunk/bin/splunk restart