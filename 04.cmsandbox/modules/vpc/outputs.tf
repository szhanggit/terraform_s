output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "public_subnet_ids" {
  value = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "aws_vpc_endpoint_s3_id" {
  value = aws_vpc_endpoint.s3.id
}

output "private_route_table_ids" {
  value = [aws_route_table.private_a.id, aws_route_table.private_b.id]
}