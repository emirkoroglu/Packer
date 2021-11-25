packer {
	required_plugins {
		amazon = {
			version = ">= 0.0.1"
			source = "github.com/hashicorp/amazon"
		}
	}
}


variable "ssh_private_key_file" {
    default = "/home/ec2-user/.ssh/id_rsa"
}

// save your local machine ssh public key to aws then replace the ssh keypair name below.
variable "ssh_keypair_name" {
    default = "terraform"
}

variable "source_ami_name" {
    default = "CentOS Linux 7 x86_64 HVM EBS ENA 1901_01-b7ee8a69-ee97-4a49-9e68-afaee216db2e-*"
}
variable "instance_type" {
    default = "t2.micro"
}
variable "ssh_username" {
    default = "centos"
}
variable "ami_name" {
    default = "bastion_wordpress_kernel_updated"
}
variable "region" {
    default = "us-east-1"
}
variable "owners" {
    default = "679593333241"
}



source "amazon-ebs" "image" {
	ami_name             = "${var.ami_name} {{timestamp}}"
	ssh_private_key_file = "${var.ssh_private_key_file}"
	ssh_keypair_name     = "${var.ssh_keypair_name}"
	instance_type        = "${var.instance_type}"
	ssh_username         = "${var.ssh_username}"
	region               = "${var.region}"
	source_ami_filter {
		most_recent = true
		owners      = ["${var.owners}"]
		filters = {
			name                = "${var.source_ami_name}"
			virtualization-type = "hvm"
			root-device-type    = "ebs"
		}
	}
	run_tags = {
		Name = "Packer instance for ${var.source_ami_name}"
	}
}

build {
	sources = [
		"source.amazon-ebs.image"
	]
	provisioner "shell" {
		inline = [
			"echo Installing Telnet",
            "sudo yum update kernel -y",
			"sudo yum install telnet -y",  #Change for ubuntu
            "sudo yum install elinks -y",   #Change for ubuntu
            "sudo yum install httpd -y",
            "sudo yum install php -y",
            "sudo systemctl restart httpd",
            "sudo systemctl enable httpd",
            "sudo yum install wget -y",
            "sudo wget https://wordpress.org/wordpress-4.0.32.tar.gz",
            "sudo tar -xf wordpress-4.0.32.tar.gz -C /var/www/html/",
            "sudo mv /var/www/html/wordpress/* /var/www/html/",
            "sudo yum install php-mysql -y",
            "sudo systemctl restart httpd",
            "sudo chown -R apache:apache /var/www/html/",
            "sudo systemctl restart httpd"
		]
	}
	provisioner "breakpoint" {
		note = "Waiting for your verification"
	}
}

