resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "movie-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "RDS subnet group"
  }
}

resource "aws_db_instance" "movie_db" {
  identifier              = "movie-db"
  allocated_storage       = 20
  engine                  = "postgres"
  #engine_version          = "14.9"
  instance_class          = "db.t3.micro"
  db_name                    = "moviedb"
  username                = var.db_user
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  multi_az                = false
  publicly_accessible     = true

  tags = {
    Name = "movie-db"
  }
}
