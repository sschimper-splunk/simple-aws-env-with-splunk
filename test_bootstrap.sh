#!/bin/bash
yum update -y
yum install httpd -y
service httpd start
cd /var/www/html
echo "<html><body><h1>Hello World - Test page</h1></body></html>" >> index.html 