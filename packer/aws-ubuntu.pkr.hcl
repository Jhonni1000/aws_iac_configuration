packer {
    required_plugins {
        amazon = {
            version = ">= 1.2.8"
            source = "github.com/hashicorp/amazon"
        }
    }
}

source "amazon-ebs" "ubuntu" {
    ami_name = "packer-linux-aws"
    instance_type = "t3.micro"
    region = "eu-north-1"

    source_ami_filter {
        filters = {
            name = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
            root-device-type = "ebs"
            virtualization-type = "hvm"
        }

        most_recent = true
        owners = ["099720109477"]
    }
    ssh_username = "ubuntu"
}

build {
    name = "ami-build"
    sources = [ 
        "source.amazon-ebs.ubuntu" 
    ]

    provisioner "shell" {
        inline = [
            
            "sudo apt update -y",
            "sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y",

            "sudo apt install -y git jq curl unzip ufw fail2ban",

            "sudo snap install amazon-ssm-agent --classic",
            "sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service",
            "sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service",

            "sudo apt install -y unattended-upgrades",
            "sudo dpkg-reconfigure -f noninteractive unattended-upgrades",

            "sudo sed -i 's/^#PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config",
            "sudo sed -i 's/^#ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config",
            "sudo systemctl restart ssh",

            "sudo apt autoremove -y",
            "sudo apt clean"
                ]
    }
}