#Create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prod-vpc.id

}
#Create a Nat Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1a.id
}
