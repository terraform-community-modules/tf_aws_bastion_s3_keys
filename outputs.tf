output "ssh_user" {
  value = "${var.ssh_user}"
}

output "security_group_id" {
  value = "${aws_security_group.bastion.id}"
}

output "dns_name" {
  value = "${aws_elb.bastion.dns_name}"
}

output "zone_id" {
  value = "${aws_elb.bastion.zone_id}"
}
