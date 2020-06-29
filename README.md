---
 title: TiendaNube
---
## Test: One

## Prerequisites

An AWS account and a Userr with permissions to create componentes.

## HOWTO Use

(This is optional, you can edit variables.tfvars file instead) The repo we have a BASH script to setup Terraform variables. You just run './prepare.sh name' where "name" is the name that you want to assing to the project. It's create a key, uploads it to AWS and set the variables to match those.

## TODO

- Add query instead of map on region - amis map.
- Prepare an S3 to host Terraform State File.
- Moify preapre.sh script to get local IP and NSG's to allow connectins only from there.
- Investigate about dual 'apt update' bug.
