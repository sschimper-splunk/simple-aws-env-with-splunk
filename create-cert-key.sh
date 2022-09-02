#! /bin/bash

echo "Creating new SSL Certificate Key..."

DIR=./.certs
if [ -d "$DIR" ]; then
  rm -r ./.certs/*
fi

openssl genrsa -out ./.certs/cert-key.pem 4096