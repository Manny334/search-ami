#!/bin/bash

apt-get install kibana -y

systemctl enable kibana

systemctl start kibana
