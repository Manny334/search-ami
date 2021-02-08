#!/bin/bash

# Installation Instructions Link: https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic.7.x.list


apt-get update -y
apt-get install elasticsearch

# starting the elastic search service

sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

# install discovery plugin
cd /usr/share/elasticsearch/bin/ && ./elasticsearch-plugin install discovery-ec2 --batch

# restarting the elastic search service

systemctl restart elasticsearch
