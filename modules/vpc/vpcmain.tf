##Created in the below structure
# VPC
# IGW
# Public RT
# Public Route
# Private RT
# Private Route
# Public Subnet
# Private Subnet
# Public RT Association
# Private RT Association

locals {
  max_subnet_length = "${max(length(var.private_subnets))}" #length(var.elasticache_subnets), length(var.database_subnets), length(var.redshift_subnets))
}

############
## VPC
############

resource "aws_vpc" "vpc" {
  count = "${var.create_vpc ? 1 : 0}"
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "${var.instance_tenancy}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"

  tags = "${merge(map("Name", var.vpc_name), var.tags)}"
}

resource "aws_internet_gateway" "this" {
  count = "${var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0}"
  
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(map("Name", var.vpc_name), var.tags)}"
}

################
# Publiс routes
################
resource "aws_route_table" "public" {
  count = "${var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0}"

  vpc_id = "${aws_vpc.vpc_id}"

  tags = "${merge(map("Name", format("rt_%s_${var.public_subnet_suffix}", var.name)), var.tags, var.public_route_table_tags)}"
}

resource "aws_route" "public_internet_gateway" {
  count = "${var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0}"

  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.this.id}"

  timeouts {
    create = "5m"
  }
}

#################
# Private routes
# There are so many routing tables as the largest amount of subnets of each type (really?)
#################
resource "aws_route_table" "private" {
  count = "${var.create_vpc && local.max_subnet_length > 0 ? 1 : 0}"

  vpc_id = "${aws_vpc.vpc_id}"

  tags = "${merge(map("Name", format("rt_%s_${var.private_subnet_suffix}", var.name)), var.tags, var.private_route_table_tags)}"

  lifecycle {
    # When attaching VPN gateways it is common to define aws_vpn_gateway_route_propagation
    # resources that manipulate the attributes of the routing table (typically for the private subnets)
    ignore_changes = ["propagating_vgws"]
  }
}

#################
## Public Subnets
#################

resource "aws_subnet" "public" {
  count = "${var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0}"

  vpc_id                  = "${aws_vpc.vpc_id}"
  cidr_block              = "${element(concat(var.public_subnets, list("")), count.index)}"
  availability_zone       = "${element(var.azs, count.index)}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

  tags = "${merge(map("Name", format("sn_%s_${var.public_subnet_suffix}_%s", var.name, element(var.sub_names, count.index))), var.tags, var.public_subnet_tags)}"
}

#################
# Private subnet
#################
resource "aws_subnet" "private" {
  count = "${var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  vpc_id            = "${aws_vpc.vpc_id}"
  cidr_block        = "${var.private_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = "${merge(map("Name", format("sn_%s_${var.private_subnet_suffix}_%s", var.name, element(var.sub_names, count.index))), var.tags, var.private_subnet_tags)}"
}

##########################
# Route table association
##########################

resource "aws_route_table_association" "public" {
  count = "${var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count = "${var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}