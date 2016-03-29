variable "name" {
  default = "bastion"
}
variable "ami" {
}
variable "instance_type" {
  default = "t2.micro"
}
variable "iam_instance_profile" {
}
variable "user_data_file" {
  default = "user_data.sh"
}
variable "s3_bucket_name" {
}
variable "s3_region" {
  default = "eu-west-1"
}
variable "ssh_user" {
  default = "ubuntu"
}
variable "enable_hourly_cron_updates" {
  default = "false"
}
variable "keys_update_frequency" {
  default = ""
}
variable "additional_user_data_script" {
  default = ""
}
variable "region" {
  default = "eu-west-1"
}
variable "vpc_id" {
}
variable "subnet_id" {
}
