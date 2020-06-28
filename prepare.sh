#/bin/bash

# Script to preapre environment to test Testone scripts

# This name must match the key name on variables.tf
NAME=$1
# Change name on variables.tf
sed -i 's/name =.*/name = '"$NAME"'/' variables.tfvars

# Configure AWS
aws configure
# Generate keys
ssh-keygen -t rsa -C $NAME -f ~/.ssh/$NAME.pem
chmod 400  ~/.ssh/$NAME.pem
sed -i 's/private_key_path =.*/private_key_path = ~\/.ssh\/'"$NAME"'.pem/' variables.tfvars
# Extract pub key
ssh-keygen -y -f ~/.ssh/$NAME.pem > ~/.ssh/$NAME.pub
chmod 444 ~/.ssh/$NAME.pub
sed -i 's/public_key_path =.*/public_key_path = ~\/.ssh\/'"$NAME"'.pub/' variables.tfvars
# Import key pair to AWS
aws ec2 import-key-pair --key-name $NAME --public-key-material fileb://~/.ssh/$NAME.pub