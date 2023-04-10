#!/usr/bin/env bash

echo "Generating session_signing_key"
ssh-keygen -t rsa -b 4096 -m PEM -N "" -C "" -f ./session_signing_key
rm session_signing_key.pub
echo ""

echo "Generating tsa_host_key"
ssh-keygen -t rsa -b 4096 -m PEM  -N "" -C "" -f ./tsa_host_key
echo ""

echo "Generating worker_key"
ssh-keygen -t rsa -b 4096 -m PEM  -N "" -C "" -f ./worker_key
echo ""
