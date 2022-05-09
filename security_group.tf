# 2. 보안그룹 생성
# 2-1. 퍼블릭 웹 서버에 대해 VPC 보안 그룹 생성
resource "aws_security_group" "terraform_sg" {
  name        = "terraform-sg"
  description = "public"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = []
    self             = false
    prefix_list_ids  = []
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = []
    self             = false
    prefix_list_ids  = []
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-sg"
  }
}

# 2-2. 프라이빗 DB 인스턴스에 대한 VPC 보안 그룹 생성
resource "aws_security_group" "terraform_db_sg" {
  name        = "terraform_db_sg"
  description = "private"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description      = "MYSQL/Aurora"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.terraform_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-db-sg"
  }
}