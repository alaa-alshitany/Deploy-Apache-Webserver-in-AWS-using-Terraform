variable "region" {
  type = string
  default = "us-east-1"
}

variable "bucket_names" {
  type = list(string)
  default = ["statefile-bk", "web-conf-bk"]
}

variable "dynamo_tb_name" {
  type = string
  default = "lock_tb"
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
