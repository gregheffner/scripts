#!/bin/bash

HOST=xxxxx
DOMAIN=xxxxx

dns_ip=$(dig $HOST.$DOMAIN +short) #Check the registered IP in DNS

        public_ip=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com|awk -F'"' '{print $2}') #Check Public IP
        if [ "$public_ip" != "$dns_ip" ]
        then
               curl  -X PUT "https://api.cloudflare.com/client/v4/zones/{zone_identifier}/dns_records/{identifier}" \
                                     -H "X-Auth-Email: whoyou@xxxx.xxxx" \
                                     -H "Authorization: Bearer xxxxxxxxxxxxxxxxxxxxxxxxxx" \
                                     -H "Content-Type: application/json" \
                                     --data '{"type":"A","name":"host.domain","content":"'"$public_ip"'","ttl":1,"proxied":false}'

        fi
