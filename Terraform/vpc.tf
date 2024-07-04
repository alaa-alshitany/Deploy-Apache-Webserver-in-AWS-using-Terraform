resource "aws_vpc" "web_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
   Name = "web_vpc"
 }
}