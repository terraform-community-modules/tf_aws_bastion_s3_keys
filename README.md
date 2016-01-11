# tf_aws_bastion_s3_keys

A Terraform module for creating bastion host on AWS EC2 and populate its ~/.ssh/authorized_keys with public keys fetched from S3 bucket.

This module can append public keys, setup cron to update them and run additional commands at the end of setup.

Only SSH access is allowed to Bastion host. 

## Input variables:

  * name - Name (default, `bastion`)
  * instance_type - Instance type (default, `t2.micro`)
  * ami_id - AMI ID of Ubuntu (see `samples/ami.tf`)
  * region - Region (default, `eu-west-1`)
  * iam_instance_profile - IAM instance profile which is allowed to access S3 bucket (see `samples/iam.tf`)
  * s3_bucket_name - S3 bucket name which contains public keys (see `samples/s3_ssh_public_keys.tf`)
  * vpc_id - VPC where bastion host should be created
  * subnet_id - Subnet ID where instance should be created
  * enable_hourly_cron_updates - Enable hourly crontab updates from S3 bucket (default, `false`)
  * additional_user_data_script - Additional user-data script to run at the end.

## Outputs:

  * instance_id - Bastion instance ID
  * ssh_user - SSH user to login to bastion
  * instance_ip - Public IP of bastion instance

## Example:

Basic example - In your terraform code add something like this:

    module "bastion" {
      source                      = "github.com/terraform-community-modules/tf_aws_bastion_s3_keys"
      instance_type               = "t2.micro"
      ami                         = "ami-123456"
      region                      = "eu-west-1"
      iam_instance_profile        = "s3-readonly"
      s3_bucket_name              = "public-keys-demo-bucket"
      vpc_id                      = "vpc-123456"
      subnet_id                   = "subnet-123456"
      enable_hourly_cron_updates  = true
      additional_user_data_script = "date"
    }

If you want to assign EIP and use Route53 to bastion instance add something like this:

    resource "aws_eip" "bastion" {
      vpc = true
      instance = "${module.bastion.instance_id}"
    }
    
    resource "aws_route53_record" "bastion" {
      zone_id = "..."
      name    = "bastion.example.com"
      type    = "A"
      ttl     = "3600"
      records = ["${aws_eip.bastion.public_ip}"]
    }

After you run `terraform apply` you should be able to login to your bastion host like:

    $ ssh ${module.bastion.ssh_user}@${module.bastion.instance_ip}

or:

    $ ssh ${module.bastion.ssh_user}@${aws_eip.bastion.public_ip}

or even like this:

    $ ssh ubuntu@bastion.example.com

PS: In some cases you may consider adding flag `-A` to ssh command to enable forwarding of the authentication agent connection.
    
##Authors

Created and maintained by [Anton Babenko](https://github.com/antonbabenko).
Heavily inspired by [hashicorp/atlas-examples](https://github.com/hashicorp/atlas-examples/tree/master/infrastructures/terraform/aws/network/bastion).

# License

Apache 2 Licensed. See LICENSE for full details.
