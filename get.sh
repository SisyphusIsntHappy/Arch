#!/bin/bash
curl https://raw.githubusercontent.com/SisyphusIsntHappy/Arch/main/install.sh > install.sh 
sed -i -e 's/\r$//' install.sh
chmod +x install.sh
