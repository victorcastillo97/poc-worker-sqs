#!/bin/bash

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
WORKING_DIR=/root/ec2-spot-labs/sqs-ec2-spot-asg

yum -y --security update

yum -y install jq ImageMagick

aws configure set default.region $REGION

cp -av $WORKING_DIR/convert-worker.conf /etc/init.d/convert-worker.conf
cp -av $WORKING_DIR/convert-worker.sh /usr/local/bin

chmod +x /usr/local/bin/convert-worker.sh

sed -i "s|%REGION%|$REGION|g" /usr/local/bin/convert-worker.sh
sed -i "s|%SQSQUEUE%|$SQSQUEUE|g" /usr/local/bin/convert-worker.sh

sh /usr/local/bin/convert-worker.sh