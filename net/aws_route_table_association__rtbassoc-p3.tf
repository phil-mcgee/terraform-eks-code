# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_route_table_association.rtbassoc-0eb5ebf6fd5e14e09:
# pm is this a throw away route table since were using only two availability zones?
resource "aws_route_table_association" "rtbassoc-0eb5ebf6fd5e14e09" {
  route_table_id = aws_route_table.rtb-0939e7f3ae6e7b829.id
  subnet_id      = aws_subnet.subnet-p3.id
}

output "rtb-priv3" {
  value = aws_route_table.rtb-0939e7f3ae6e7b829.id
}