data "aws_ami" "nat_and_bastion_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-hvm-2018.03.0.20181116-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "keypair" {
  key_name   = var.keypair["name"]
  public_key = var.keypair["value"]
}

resource "aws_instance" "nat_and_bastion" {
  ami                         = data.aws_ami.nat_and_bastion_linux.id
  instance_type               = "t2.micro"
  availability_zone           = var.azs[0]
  source_dest_check           = true
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg_public.id]
  key_name                    = var.keypair["name"]

  tags = {
    Name = "Nat and Bastion"
  }
}
