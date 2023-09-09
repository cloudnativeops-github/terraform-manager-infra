resource "aws_vpc" "vpc-local" {
  cidr_block           = var.vpccidr
  enale_dns_support    = true
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