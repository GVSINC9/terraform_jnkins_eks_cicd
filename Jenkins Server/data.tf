data "aws_ami" "example" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    #values = ["ami-02c21308fed24a8ab"]
    #values = ["amzn2-ami-kernel-*-x86_64-gp2"]
    values = ["amzn-ec2-macos*"]
    
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_availability_zones" "azs" {

}