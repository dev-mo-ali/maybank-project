variable "region" {
  default = "us-east-1"
}



variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true


}
variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true

}



variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["172.16.1.0/24", "172.16.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["172.16.3.0/24", "172.16.4.0/24"]
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "password"
}

variable "ami_id" {
  default = "ami-12345678"
}
