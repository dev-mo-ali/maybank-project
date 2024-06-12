/*
 Create a data object called "ubuntu" that holds the
  latest Ubuntu 22.04 server AMI
*/

data "aws_ami" "ubuntu" {
  most_recent = "true"
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server*"] 
    // for arm64 - t4g instance
    # values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}
