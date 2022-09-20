#!/bin/bash
read -p "please your username: " NAME
easyrsa build-client-full $NAME nopass
ovpn_getclient $NAME > /etc/openvpn/"$NAME".ovpn