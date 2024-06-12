
resource "aws_security_group" "web_sg" {
  vpc_id      = aws_vpc.main.id
  name        = ""
  description = ""

  ingress {
    description = "Allow all traffic through HTTP"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow all traffic through HTTPS"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "Web Security Group"
    Description = "Security group for web API servers, allowing HTTP and HTTPS traffic"
    CreatedBy   = "terraform",
  }
  lifecycle {
    prevent_destroy = true
  }
}

data "aws_security_group" "database_sg" {
  name = "database_sg"
}
# Create a security group for the ec2 instances to access the database sg called "database_sg"
resource "aws_security_group" "ec2_rds_sg" {
  name        = "ec2_rds_sg"
  description = "Security group for ec2 instances to access the database rds"

  # To add this egress rule after database_sg is created
  egress {
    description     = "Rule to allow connections to  database-instance from any instances this security group is attached to"
    from_port       = "3306"
    to_port         = "3306"
    protocol        = "tcp"
    security_groups = [data.aws_security_group.database_sg.id] // destination sg
  }

  tags = {
    Name        = "ec2_rds_sg"
    Description = "Security group for ec2 instances to access the database sg"
  CreatedBy = "terraform", }

}
# Create a security group for the RDS instances called "db_sg"
resource "aws_security_group" "database_sg" {
  name        = "database_sg"
  description = "Security group for rds databases"

  ingress {
    description     = "Rule to allow connections from EC2 instances with ec2_rds_sg attached"
    from_port       = "3306"
    to_port         = "3306"
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_rds_sg.id] // source sg
  }

  tags = {
    Name        = "database_sg"
    Description = "Security group for rds databases, allowing MySQL traffic from only the web sg"
  CreatedBy = "terraform", }
  lifecycle {
    prevent_destroy = true
  }
}
