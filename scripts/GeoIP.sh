#!/bin/bash
set -xe

AWS_DEFAULT_REGION=us-west-2 aws ssm get-parameter --name /common/GeoIP.conf --with-decryption --query 'Parameter.Value' > /usr/local/etc/GeoIP.conf
