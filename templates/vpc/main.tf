module "vpc" {
  source = "../../../modules/vpc"

  name = "${var.name}"
  cidr = "${var.network["cidr"]}"
  azs             = ["${var.location["az1"]}", "${var.location["az2"]}", "${var.location["az3"]}"]
  private_subnets = ["${var.network["sub_pri_1a"]}", "${var.network["sub_pri_1b"]}", "${var.network["sub_pri_1c"]}", "${var.network["sub_pri_2a"]}", "${var.network["sub_pri_2b"]}", "${var.network["sub_pri_2c"]}"]
  public_subnets  = ["${var.network["sub_pub_1a"]}", "${var.network["sub_pub_1b"]}", "${var.network["sub_pub_1c"]}", "${var.network["sub_pub_2a"]}", "${var.network["sub_pub_2b"]}", "${var.network["sub_pub_2c"]}"]
  tags = "${var.common_tags}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_default_security_group_id" {
  value = "${module.vpc.default_security_group_id}"
}

output "private_subnet_ids" {
  value = "${module.vpc.private_subnets}"
}

output "public_subnet_ids" {
  value = "${module.vpc.public_subnets}"
}

output "public_route_table_ids" {
  value = "${module.vpc.public_route_table_ids}"
}


output "private_route_table_ids" {
  value = "${module.vpc.private_route_table_ids}"
}