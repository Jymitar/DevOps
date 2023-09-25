#!/bin/bash

# 
# Create Jenkins job
# 

java -jar /home/vagrant/jenkins-cli.jar -s http://192.168.69.121:8080/ -http -auth jmy:jmypass create-job treasure-finding-contest < /vagrant/jenkins/job.xml
