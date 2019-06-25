#!/bin/bash

#################################################################################
#                                                                               #
# Script that receives a domain name has a parameter and returns the expiry date#
#                                                                               #
# Execution: domain_expiry.sh domain.com                                        #
# Returns: 25/12/2022                                                           #
# author: https://github.com/caioz7                                             #
#                                                                               #
#################################################################################

DOMAIN=$1

echo "$DOMAIN" | grep -ie "\.br" > /dev/null
RET=$?

if [ "$RET" -eq 0 ]; then
    EXPIRY_DATE=$(whois "$DOMAIN" | grep expires | awk '{print $2}') > /dev/null
else
    EXPIRY_DATE=$(whois "$DOMAIN" | grep Expiry | awk '{print $4}' | cut -c1-10) > /dev/null
fi

date -d "$EXPIRY_DATE" +%d-%m-%Y
