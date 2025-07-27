//Fatching the amis

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  // ... other instance configurations
}

data "aws_availability_zones" "azs" {} //data source 2
