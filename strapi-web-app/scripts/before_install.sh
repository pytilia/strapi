#!/bin/bash

# Check for ansible tools, and attempt to install if not
. $(dirname $0)/common_variables.sh

yum list installed python-pip &> /dev/null
if [ $? != 0 ]; then
    yum install -y python-pip
fi

pip list | grep -q ansible
if [ $? != 0 ]; then
    pip install ansible
fi

pip list | grep -q python3
if [ $? != 0 ]; then
    sudo yum install -y python3
fi

ansible-playbook $(dirname $0)/ansible/nginx.yaml --connection=local

sudo rm -rf $DESTINATION_PATH/index.html