#!/bin/bash
read -p "Delete username: " DNAME
easyrsa revoke $DNAME
easyrsa gen-crl
rm -f /etc/openvpn/pki/reqs/"DNAME".req
rm -f /etc/openvpn/pki/private/"DNAME".key
rm -f /etc/openvpn/pki/issued/"DNAME".crt