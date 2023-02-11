output "subnets_ids" {
  value = [ aws_subnet.sub1.id, aws_subnet.sub2.id ] 
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}