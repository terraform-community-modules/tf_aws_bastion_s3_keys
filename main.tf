resource "aws_security_group" "bastion" {
  name        = "${var.name}"
  vpc_id      = "${var.vpc_id}"
  description = "Bastion security group (only SSH inbound access is allowed)"

  tags {
    Name = "${var.name}"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "template_file" "user_data" {
  template = "${file("${path.module}/${var.user_data_file}")}"

  vars {
    s3_bucket_name = "${var.s3_bucket_name}"
    ssh_user       = "${var.ssh_user}"
  }
}

resource "aws_instance" "bastion" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  user_data              = "${template_file.user_data.rendered}"

  count                  = 1

  tags {
    Name = "${var.name}"
  }
}