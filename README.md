# Packer
Installing Packer &amp; Building an AMI image with Packer

Run the below commands to install the Packer on CentOS7

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install packer
