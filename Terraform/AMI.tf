resource "aws_ami_from_instance" "golden_ami" {
  name = "golden-ami"
  source_instance_id = "i-0bdc40e7a06eefaff"
}