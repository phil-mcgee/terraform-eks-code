# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_route_table_association.rtbassoc-08fc27d0456901ef8:
# pm is this a throw away route table since were using only two availability zones?
resource "aws_route_table_association" "rtbassoc-08fc27d0456901ef8" {
  route_table_id = aws_route_table.rtb-0329e787bbafcb2c4.id
  subnet_id      = aws_subnet.subnet-i3.id
}
