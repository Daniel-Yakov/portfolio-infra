output "subnets_ids" {
  value = [ aws_subnet.sub1.id, aws_subnet.sub2.id ] 
  description = "The subnets created in this module"
}