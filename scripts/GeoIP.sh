#!/bin/bash
set -xe

aws ssm get-parameter --name /common/GeoIP.conf --with-decryption --query 'Parameter.Value' > /usr/local/etc/GeoIP.conf
