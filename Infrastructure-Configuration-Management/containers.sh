#!/bin/bash

echo "* Add EPEL repository ..."
dnf install -y epel-release

echo "* Install Python3 ..." 
dnf install -y python3 python3-pip

echo "* Install Python docker module ..."
pip3 install docker

echo "*Download and Install Terraform"
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform