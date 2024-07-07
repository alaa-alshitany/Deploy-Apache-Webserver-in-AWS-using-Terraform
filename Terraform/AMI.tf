resource "aws_ami_from_instance" "golden_ami" {
  name = "golden-ami"
  source_instance_id = "i-081dce8df72a32982"
}