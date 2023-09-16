resource "aws_vpc" "vpc-local" {
  cidr_block           = var.vpccidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.vpctag
}

resource "aws_subnet" "pub" {
  count                   = length(var.pub_cidrs)
  vpc_id                  = aws_vpc.vpc-local.id
  cidr_block              = element(var.pub_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags                    = element(var.pubtags, count.index)
}

resource "aws_subnet" "pri" {
  count             = length(var.pri_cidrs)
  vpc_id            = aws_vpc.vpc-local.id
  cidr_block        = element(var.pri_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags              = element(var.pritags, count.index)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-local.id
  tags   = var.pubtag
}

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.vpc-local.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = var.pubtag
}

data "aws_subnets" "public" {
  depends_on = [aws_subnet.pub]
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc-local.id]
  }

  tags = {
    Name = "pub-*"
  }
}

resource "aws_route_table_association" "pub1-rt-ass" {
  depends_on     = [aws_subnet.pub]
  count          = length(var.pub_cidrs)
  route_table_id = aws_route_table.pub-rt.id
  subnet_id      = element(data.aws_subnets.public.ids, count.index)
}

resource "aws_route_table" "pri-rt" {
  count      = var.allow-eip == false ? 0 : 1
  depends_on = [aws_nat_gateway.nat-gw]
  vpc_id     = aws_vpc.vpc-local.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw[0].id
  }
  tags = var.pritag
}

data "aws_subnets" "private" {
  depends_on = [aws_subnet.pri]
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc-local.id]
  }

  tags = {
    Name = "pri-*"
  }
}

resource "aws_route_table_association" "pri1-rt-ass" {
  depends_on     = [aws_subnet.pri]
  count          = var.allow-eip == false ? 0 : length(var.pri_cidrs)
  route_table_id = aws_route_table.pri-rt[0].id
  subnet_id      = element(data.aws_subnets.private.ids, count.index)
}

resource "aws_eip" "nat-gw-eip" {
  count = var.allow-eip == false ? 0 : 1
}

resource "aws_nat_gateway" "nat-gw" {
  count         = var.allow-eip == false ? 0 : 1
  subnet_id     = element(data.aws_subnets.public.ids, 0)
  allocation_id = aws_eip.nat-gw-eip[0].id
  depends_on    = [aws_eip.nat-gw-eip]
}