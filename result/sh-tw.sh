#!/bin/bash
# AUTO-Generated by recolic xingmeng fucker, at Tue 11 Feb 2020 10:41:14 AM UTC
password="G9hy4mchacha20"
obfs_param="86e1a3958.microsoft.com"
protocol_param="3958:cqNL5f"

sslocal -b 0.0.0.0 -l 10808     -s sh.xmshuju.xyz -p 16325 -k "$password" -o tls1.2_ticket_auth -g "$obfs_param" -O auth_aes128_md5 -G "$protocol_param"

