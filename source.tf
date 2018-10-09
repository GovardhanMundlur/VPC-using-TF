provider "aws" {
  region = "${var.reg}"
}

locals {
  vpc-id = "${aws_vpc.vpc-tf.id}"
  public-id = "${aws_subnet.public.id}"
  private-id = "${aws_subnet.private.id}"
  ig-id = "${aws_internet_gateway.ig.id}"
  nat-id = "${aws_nat_gateway.ng.id}"
  route-table-public = "${aws_default_route_table.route-public.id}"
  route-table-private = "${aws_route_table.route-private.id}"
}

resource "aws_vpc" "vpc-tf" {
  cidr_block = "${var.vpc-cidr-range}"
  tags {
    Name = "${var.vpc-name}"
  }
}

data "aws_availability_zones" "AZ" {}

resource "aws_default_route_table" "route-public" {
  default_route_table_id = "${aws_vpc.vpc-tf.default_route_table_id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${local.ig-id}"
  }
  tags {
    Name = "${var.vpc-name}"
  }
}


resource "aws_route_table_association" "route-subnet-public" {
  route_table_id = "${aws_default_route_table.route-public.id}"
  subnet_id = "${local.public-id}"
}

resource "aws_subnet" "public" {
  count = "${var.AZ-count}"
  availability_zone = "${data.aws_availability_zones.AZ.names[count.index]}"
  cidr_block = "${var.public-id}"
  vpc_id = "${local.vpc-id}"
  tags {
    Name = "${var.vpc-name}"
  }
}

resource "aws_subnet" "private" {
  count = "${var.AZ-count}"
  availability_zone = "${data.aws_availability_zones.AZ.names[count.index]}"
  cidr_block = "${var.private-id}"
  vpc_id = "${local.vpc-id}"
  tags {
    Name = "${var.vpc-name}"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = "${local.vpc-id}"
  tags {
    Name = "${var.vpc-name}"
  }
}

resource "aws_eip" "nat-ip" {
  vpc = true
  tags {
    Name = "${var.vpc-name}"
  }
}

resource "aws_nat_gateway" "ng" {
  allocation_id = "${aws_eip.nat-ip.id}"
  subnet_id = "${local.public-id}"
  tags {
    Name = "${var.vpc-name}"
  }
}

resource "aws_route_table" "route-private" {
  vpc_id = "${local.vpc-id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${local.nat-id}"
    
  }
  tags {
    Name = "${var.vpc-name}"
  }
}

resource "aws_route_table_association" "private-subnet-route" {
  route_table_id = "${local.route-table-private}"
  subnet_id = "${local.private-id}"
}