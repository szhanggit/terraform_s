resource "aws_eip" "nat" {
  tags = {
    Name        = "nat-eip-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id

  tags = {
    Name        = "nat-gateway-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_route" "private_nat" {
  for_each = var.private_route_table_ids
  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
