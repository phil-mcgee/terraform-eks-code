# File generated by aws2tf see https://github.com/aws-samples/aws2tf
# aws_route_table.rtb-0102c621469c344cd:
resource "aws_route_table" "rtb-0102c621469c344cd" {
  propagating_vgws = []
  route            = []
  tags = {
    "Name" = "eks-cluster/PrivateRouteTableUSEAST1B"

  }
  vpc_id = aws_vpc.cluster.id
}
