output "vpc-id" {
  value = "${local.vpc-id}"
}

output "subnet-public" {
  value = "${local.public-id}"
}

output "subnet-private" {
  value = "${local.private-id}"
}

output "ig-id" {
  value = "${local.ig-id}"
}

output "nat-id" {
  value = "${local.nat-id}"
}

output "route-table-public" {
  value = "${local.route-table-public}"
}

output "route-table-private" {
  value = "${local.route-table-public}"
}