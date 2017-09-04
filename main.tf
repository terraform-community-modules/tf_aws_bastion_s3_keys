resource "aws_security_group" "bastion" {
  name        = "${var.name}"
  vpc_id      = "${var.vpc_id}"
  description = "Bastion security group (elb to instance access on port 22)"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_security_group" "elb" {
  name        = "${var.name}-elb"
  vpc_id      = "${var.vpc_id}"
  description = "elb security group (inbound access to configured ssh port)"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = "${var.ssh_port}"
  to_port           = "${var.ssh_port}"
  protocol          = "tcp"
  cidr_blocks       = "${var.allowed_cidr}"
  ipv6_cidr_blocks  = "${var.allowed_ipv6_cidr}"
  security_group_id = "${aws_security_group.elb.id}"
}

resource "aws_security_group_rule" "ssh_internal" {
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.elb.id}"
  security_group_id        = "${aws_security_group.bastion.id}"
}

resource "aws_security_group_rule" "ssh_sg_ingress" {
  count                    = "${length(var.allowed_security_groups)}"
  type                     = "ingress"
  from_port                = "${var.ssh_port}"
  to_port                  = "${var.ssh_port}"
  protocol                 = "tcp"
  source_security_group_id = "${element(var.allowed_security_groups, count.index)}"
  security_group_id        = "${aws_security_group.elb.id}"
}

resource "aws_security_group_rule" "bastion_all_egress" {
  type              = "egress"
  from_port         = "0"
  to_port           = "65535"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = "${aws_security_group.bastion.id}"
}

resource "aws_security_group_rule" "elb_egress" {
  type                     = "egress"
  from_port                = "0"
  to_port                  = "65535"
  protocol                 = "all"
  source_security_group_id = "${aws_security_group.bastion.id}"
  security_group_id        = "${aws_security_group.elb.id}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/${var.user_data_file}")}"

  vars {
    s3_bucket_name              = "${var.s3_bucket_name}"
    s3_bucket_uri               = "${var.s3_bucket_uri}"
    ssh_user                    = "${var.ssh_user}"
    keys_update_frequency       = "${var.keys_update_frequency}"
    enable_hourly_cron_updates  = "${var.enable_hourly_cron_updates}"
    additional_user_data_script = "${var.additional_user_data_script}"
  }
}

resource "aws_launch_configuration" "bastion" {
  name_prefix       = "${var.name}-"
  image_id          = "${var.ami}"
  instance_type     = "${var.instance_type}"
  user_data         = "${data.template_file.user_data.rendered}"
  enable_monitoring = "${var.enable_monitoring}"

  security_groups = [
    "${aws_security_group.bastion.id}",
  ]

  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name                    = "${var.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  name = "${var.name}"

  vpc_zone_identifier = [
    "${var.subnet_ids}",
  ]

  desired_capacity          = "1"
  min_size                  = "1"
  max_size                  = "1"
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = "${aws_launch_configuration.bastion.name}"

  load_balancers = [
    "${aws_elb.bastion.id}",
  ]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  tag {
    key                 = "Name"
    value               = "${var.name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "EIP"
    value               = "${var.eip}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "bastion" {
  name = "${var.name}"

  subnets = [
    "${var.subnet_ids}",
  ]

  listener {
    instance_port     = "22"
    instance_protocol = "tcp"
    lb_port           = "${var.ssh_port}"
    lb_protocol       = "tcp"
  }

  security_groups = [
    "${compact(concat(list(aws_security_group.elb.id), split(",", "${var.security_group_ids}")))}",
  ]
}
