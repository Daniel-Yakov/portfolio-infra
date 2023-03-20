# Information on the az of the current region
data "aws_availability_zones" "az" {}

// Create first subnet
resource "aws_subnet" "sub1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_block[0]
  availability_zone = data.aws_availability_zones.az.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnets_name[0]
  }
}

// Create second subnet
resource "aws_subnet" "sub2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_block[1]
  availability_zone = data.aws_availability_zones.az.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnets_name[1]
  }
}

// Associate first subnet to route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt.id
}

// Associate second subnet to route table
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt.id
}
