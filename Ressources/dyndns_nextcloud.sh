#!/bin/bash

#Define your OVH DynHost ID & password and the domain name for which you wish to update DynHost
DYNHOST_ID='your_dynHost'
DYNHOST_PASSWORD='super_secret'
DOMAIN_NAME='example.com'

#####################
####DO NOT TOUCH#####
#####################

PUBLIC_IP=$(curl --silent ifconfig.co)

#Call OVH for update
curl --silent --user "$DYNHOST_ID:$DYNHOST_PASSWORD" "https://www.ovh.com/nic/update?system=dyndns&hostname=$DOMAIN_NAME&myip=$PUBLIC_IP"
