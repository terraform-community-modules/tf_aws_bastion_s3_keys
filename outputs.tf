output "instance_id" {
  value = "${aws_instance.bastion.id}"
}

output "instance_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "ssh_user" {
  value = "${var.ssh_user}"
}

output "security_group_id" {
  value = "${aws_security_group.bastion.id}"
}
