## VPC 
# 1-1. VPC 생성 
resource "aws_vpc" "terraform_vpc"{
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
        Name = "terraform_vpc"
    }
}
#----------------------------------------------------------------#
# 1-2. public subnet 생성
resource "aws_subnet" "terraform_public_1" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "terraform-public-1"
  }
}

resource "aws_subnet" "terraform_public_2" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "terraform-public-2"
  }
}

# 1-3. private subnet 생성
resource "aws_subnet" "terraform_private_1" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "terraform-private-1"
  }
}

resource "aws_subnet" "terraform_private_2" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "terraform-private-2"
  }
}

#----------------------------------------------------------------#
# 1-4. igw 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform-igw"
  }
}
#----------------------------------------------------------------#
# 1-5 라우팅 테이블 생성
# 1-5-1. igw와 연결된 public 생성
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "terraform-public"
  }
}

# 1-5-2. private를 위한 nat 설정
resource "aws_nat_gateway" "terraform_nat_1" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.terraform_private_1.id
}

resource "aws_nat_gateway" "terraform_nat_2" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.terraform_private_2.id
}

# 1-5-3. nat과 private 연결
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.terraform_nat_1.id
  }

  tags = {
    Name = "terraform-private-1"
  }
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.terraform_nat_2.id
  }

  tags = {
    Name = "terraform-private-2"
  }
}

#1-6. Elastic IP 
resource "aws_eip" "ngw_eip" {
  vpc      = true
}

#1-7. 라우팅 테이블과 서브넷 또는 라우팅 테이블과 인터넷 게이트웨이 또는 가상 프라이빗 게이트웨이 간의 연결을 생성
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.terraform_public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.terraform_public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.terraform_private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.terraform_private_2.id
  route_table_id = aws_route_table.private_2.id
}
