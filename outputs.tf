output "ssh_user" {
  value = "${var.ssh_user}"
}

output "security_group_id" {
  value = "${element(concat(aws_security_group.bastion.*.id, list("")), 0)}"
}

output "asg_id" {
  value = "${element(concat(aws_autoscaling_group.bastion.*.id, list("")), 0)}"
}
