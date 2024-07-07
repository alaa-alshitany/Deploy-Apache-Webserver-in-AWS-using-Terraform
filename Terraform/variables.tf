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

variable "public_subnet_cidr" {
 type        = list(string)
 description = "Public Subnet CIDR"
 default     = ["10.0.1.0/24","10.0.2.0/24" ]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.3.0/24", "10.0.4.0/24"]
}