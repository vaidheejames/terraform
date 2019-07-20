module "vpc" {
  source = "../../modules/vpc"

  aws_region = "${var.aws_region}"
  aws_zones = "${var.aws_zones}"
  vpc_name = "${var.vpc_name}"
  vpc_cidr = "${var.vpc_cidr}"
  private_subnets = "${var.private_subnets}"

  ## Tags
  tags = "${var.tags}"
}
output "vpc" {
  value = "${module.vpc.vpc_id}"
}

output "subnets" {
  value = "${module.vpc.subnet_ids}"
}

output "private_subnets" {
  value = "${module.vpc.private_subnet_ids}"
}