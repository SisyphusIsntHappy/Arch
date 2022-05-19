#!/bin/bash
curl https://raw.githubusercontent.com/SisyphusIsntHappy/Arch/main/install.sh > install.sh 
sed -i -e 's/\r$//' i
chmod +x install.sh
