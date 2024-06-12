# RDS Instance (Master)
resource "aws_db_instance" "mariadb_master" {
  identifier = "master-db"
  allocated_storage      = 20
  max_allocated_storage  = 1000
  storage_type           = "gp3"
  engine                 = "mysql"
  engine_version         = "8.0.33"
  instance_class         = "db.t3.small"
  db_name = "master_db"
  username               = "admin"
  password               = "password"
  port                   = 3306
  deletion_protection = true
  publicly_accessible = false
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database_sg.id]

  tags = {
    Name = "db Master"
    Description = "db Master"
    CreatedBy   = "terraform"
  }
  lifecycle {
    prevent_destroy = true
  }
  depends_on = []

}

# RDS Instance (Replica)
resource "aws_db_instance" "mariadb_replica" {
  identifier = "replica-db"
  allocated_storage      = 20
  max_allocated_storage  = 1000
  engine                 = "mysql"
  engine_version         = "8.0.33"
  instance_class         = "db.t3.small"

  replicate_source_db    = aws_db_instance.mariadb_master.id
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.database_sg.id]

  tags = {
    Name = "db Replica"
    Description = "db Replica"
    CreatedBy   = "terraform"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "Main"
    Description = "Main Subnet Group"
    CreatedBy   = "terraform"
  }
}


