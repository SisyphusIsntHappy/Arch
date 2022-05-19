#!/bin/bash
curl https://pastebin.com/raw/TGVQi1y5 > install.sh 
sed -i -e 's/\r$//' /mnt/install.sh 
chmod +x install.sh
