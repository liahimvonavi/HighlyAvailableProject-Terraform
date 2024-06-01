#Create DB
#Db CLuster
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-db-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.05.2"
  master_username         = "*"
  master_password         = "*"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_grp.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot = true
 
}
#DB Instance
resource "aws_rds_cluster_instance" "aurora_instance" {
  count              = 2
  identifier         = "aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version
  publicly_accessible = false
  db_subnet_group_name = aws_db_subnet_group.aurora_subnet_grp.id
  
}

# Security Group for Aurora
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.prod-vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_grp.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Subnet group for Aurora
resource "aws_db_subnet_group" "aurora_subnet_grp" {
  name       = "aurora-subnet-group"
  subnet_ids = [aws_subnet.db_1a.id, aws_subnet.db_1b.id]
}
