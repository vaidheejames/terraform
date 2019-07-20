
variable aws_region {
  type = "string"
  description = "AWS region which should be used"
}

variable aws_zones {
  type = "list"
  description = "list of AZ's available to that particular region"
}

variable vpc_name {
  type = "string"
  description = "Name for the VPC"
  default = "terraform-vpc"
}

variable vpc_cidr {
  type = "string"
  description = "CIDR range for the VPC"
  default = "10.0.0.0/16"
}

variable private_subnets {
  type = "string"
  description = "Mention whether the private subnet is needed or not"
  default = false
}

variable tags {
  type = "map"
  description = "List of Tags"
}