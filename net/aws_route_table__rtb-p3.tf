# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_route_table.rtb-0939e7f3ae6e7b829:

# pm is this a throw away route table since were using only two availability zones?
resource "aws_route_table" "rtb-0939e7f3ae6e7b829" {
  propagating_vgws = []
  route            = []
  tags = {
    "Name" = "eks-cluster/PrivateRouteTableUSEAST1C"

  }
  vpc_id = aws_vpc.cluster.id
}
