# Author: Veer Garapati
# Date: 2021-07-25
# Purpose: This file is used to create Jenkins server and EKS cluster using terraform
# shorten the path in command line by using alias prompt $g

# Create a VPC
#using terraform-aws-modules/vpc/aws module https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  azs = data.aws_availability_zones.azs.names
  # private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = var.public_subnets
  map_customer_owned_ip_on_launch = true

  enable_dns_hostnames = true

  tags = {
    Name        = "jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "jenkins-public-subnet"
  }
}

# security group for EKS https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-sg"
  description = "Security group for jenkins server"
  vpc_id      = module.vpc.vpc_id


  #ingress rules
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8082
      protocol    = "tcp"
      description = "http"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"

    }
  ]

  #engress rules
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name        = "jenkins-sg"
    Terraform   = "true"
    Environment = "dev"
  }

}
#Create Ec2 instance for Jenkins https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-server"

  instance_type               = var.instance_type
  key_name                    = "awssshdemo"
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("jenkins-install.sh")
  availability_zone           = data.aws_availability_zones.azs.names[0]

  tags = {
    Name        = "Jenkins-Server"
    Terraform   = "true"
    Environment = "dev"
  }
}