#!/usr/bin/env sh
#################################################################################
#                                                                               #
# Script that receives a domain name has a parameter and returns the expiry date#
#                                                                               #
# Execution: domain_expiry.sh domain.com                                        #
# Returns: 25/12/2022                                                           #
# author: https://github.com/caioz7                                             #
#                                                                               #
# Need whois installed:                                                         #
# yum install whois		#RHEL/CentOS                                            #
# dnf install whois		#Fedora 22+                                             #
# apt install whois	    #Debian/Ubuntu                                          #
#################################################################################
#set -x

trap 'REM_TMP_FILES' 0 1 2 3 6 14 15

WHOIS_FILE=$(mktemp /tmp/WHOIS_FILE_XXXX.txt)
DOMAIN=$1

VERIFY_DOMAIN(){
if [ "$1" -eq 0 ]; then
    echo "Domain not recognized by WHOIS, please check the domain name again!"
    exit 1
fi
}

REM_TMP_FILES(){
    rm -f /tmp/WHOIS_FILE_* > /dev/null
}

whois "$DOMAIN" > "$WHOIS_FILE"

grep -iE "(no match for|client are not permitted)" "$WHOIS_FILE" > /dev/null
VERIFY_DOMAIN "$?"


echo "$DOMAIN" | grep -ie "\.br" > /dev/null
RET=$?
if [ "$RET" -eq 0 ]; then
    EXPIRY_DATE=$(grep expires "$WHOIS_FILE" | awk '{print $2}')
else
    EXPIRY_DATE=$(grep Expiry "$WHOIS_FILE"| awk '{print $4}' | cut -c1-10)
fi
if [ "$EXPIRY_DATE" != "" ]; then
    date -d "$EXPIRY_DATE" +%d-%m-%Y
    exit 0
else
    echo "Expiry Date NOT FOUND!"
    exit 1
fi
