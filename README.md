# tf_aws_bastion_s3_keys

A Terraform module for creating resilient bastion host using auto-scaling group (min=max=desired=1) and populate its
`~/.ssh/authorized_keys` with public keys fetched from S3 bucket.

This module can append public keys, setup cron to update them and run
additional commands at the end of setup. Note that if it is set up to
update the keys, removing a key from the bucket will also remove it from
the bastion host.

Only SSH access is allowed to the bastion host.

## Input variables:

  * `name` - Name (default, `bastion`)
  * `instance_type` - Instance type (default, `t2.micro`)
  * `ami` - AMI ID of Ubuntu (see `samples/ami.tf`)
  * `region` - Region (default, `eu-west-1`)
  * `iam_instance_profile` - IAM instance profile which is allowed to access S3 bucket (see `samples/iam_s3_readonly.tf`)
  * `enable_monitoring` - Whether to enable detailed monitoring (default, `true`)
  * `s3_bucket_name` - S3 bucket name which contains public keys (see `samples/s3_ssh_public_keys.tf`)
  * `s3_bucket_uri `– S3 URI which contains the public keys. If specified, `s3_bucket_name` will be ignored
  * `vpc_id` - VPC where bastion host should be created
  * `subnet_ids` - List of subnet IDs where auto-scaling should create instances
  * `keys_update_frequency` - How often to update keys. A cron timespec or an empty string to turn off (default)
  * `additional_user_data_script` - Additional user-data script to run at the end
  * `associate_public_ip_address` - Whether to auto-assign public IP to the instance (by default - `false`)
  * `eip` - EIP to put into EC2 tag (can be used with scripts like https://github.com/skymill/aws-ec2-assign-elastic-ip, default - empty value)
  * `key_name` - Launch configuration key name to be applied to created instance(s).
  * `allowed_cidr` - A list of CIDR Networks to allow ssh access to. Defaults to "0.0.0.0/0"
  * `allowed_ipv6_cidr` - A list of IPv6 CIDR Networks to allow ssh access to. Defaults to "::/0"
  * `allowed_security_groups` - A list of Security Group ID's to allow access to the bastion host (useful if bastion is deployed internally) Defaults to empty list

## Outputs:

  * ssh_user - SSH user to login to bastion
  * security_group_id - ID of the security group the bastion host is launched in.

## Example:

Basic example - In your terraform code add something like this:

    module "bastion" {
      source                      = "github.com/terraform-community-modules/tf_aws_bastion_s3_keys"
      instance_type               = "t2.micro"
      ami                         = "ami-123456"
      region                      = "eu-west-1"
      iam_instance_profile        = "s3_readonly"
      s3_bucket_name              = "public-keys-demo-bucket"
      vpc_id                      = "vpc-123456"
      subnet_ids                  = ["subnet-123456", "subnet-6789123", "subnet-321321"]
      keys_update_frequency       = "5,20,35,50 * * * *"
      additional_user_data_script = "date"
    }

If you want to assign EIP to instance launched by auto-scaling group you can provide desired `eip` as module input
and then execute `additional_user_data_script` which sets EIP. This way you can use Route53 with EIP, which will always
point to existing bastion instance.  You will also need to add allow_associateaddress permission to iam_instance_profile (see `samples/iam_allow_associateaddress.tf`):

    module "bastion" {
      // see above
      eip = "${aws_eip.bastion.public_ip}"
      iam_instance_profile        = "s3_readonly-allow_associateaddress"
      additional_user_data_script = <<EOF
    REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
    INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    aws ec2 associate-address --region $REGION --instance-id $INSTANCE_ID --allocation-id ${aws_eip.bastion.id}
    EOF
    }

    resource "aws_eip" "bastion" {
      vpc = true
    }

    resource "aws_route53_record" "bastion" {
      zone_id = "..."
      name    = "bastion.example.com"
      type    = "A"
      ttl     = "3600"
      records = ["${aws_eip.bastion.public_ip}"]
    }

After you run `terraform apply` you should be able to login to your bastion host like:

    $ ssh ${module.bastion.ssh_user}@${aws_eip.bastion.public_ip}

or even like this:

    $ ssh ubuntu@bastion.example.com

PS: In some cases you may consider adding flag `-A` to ssh command to enable forwarding of the authentication agent connection.

##Authors

Created and maintained by [Anton Babenko](https://github.com/antonbabenko).
Heavily inspired by [hashicorp/atlas-examples](https://github.com/hashicorp/atlas-examples/tree/master/infrastructures/terraform/aws/network/bastion).

# License

Apache 2 Licensed. See LICENSE for full details.
