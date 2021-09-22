<a name="unreleased"></a>
## [Unreleased]



<a name="v2.0.0"></a>
## [v2.0.0] - 2020-01-07

- Updated CHANGELOG
- Added git-chklog files
- Fixed for Terraform 0.12
- Support for Terraform 0.12 (fixes [#55](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/55)) ([#56](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/56))


<a name="v1.10.0"></a>
## [v1.10.0] - 2018-10-31

- Fix typo in title ([#50](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/50))
- :recycle: Run apt or yum if available but not both ([#52](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/52))


<a name="v1.9.0"></a>
## [v1.9.0] - 2018-10-31

- Simplification ([#53](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/53))

### 

* Remove `file()` call as the resources provides an `source` attribute to read local file


<a name="v1.8.1"></a>
## [v1.8.1] - 2018-08-16

- Updated CHANGELOG
- Small tidy up of README ([#47](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/47))


<a name="v1.8.0"></a>
## [v1.8.0] - 2018-04-11

- Fixed formatting
- Updated changelog
- Reload via name change ([#45](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/45))


<a name="v1.7.0"></a>
## [v1.7.0] - 2018-04-03

- Updated changelog for v1.7.0


<a name="v1.6.0"></a>
## [v1.6.0] - 2018-04-03

- Updated changelog for v1.6.0
- Updated changelog
- Added pre-commit hooks
- Fixed formatting
- Add the root volume size as a variable ([#42](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/42))


<a name="v1.5.0"></a>
## [v1.5.0] - 2018-04-03

- Replace older local keys with newer S3 keys ([#43](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/43))
- Add asg_id output ([#41](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/41))


<a name="v1.3.1"></a>
## [v1.3.1] - 2018-02-16



<a name="v1.4.0"></a>
## [v1.4.0] - 2018-02-16

- Fix deprecation warning ([#40](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/40))

### 

* aws_iam_instance_profile.s3_readonly-allow_associateaddress: "roles": [DEPRECATED] Use `role` instead. Only a single role can be passed to an IAM Instance Profile


<a name="v1.3.0"></a>
## [v1.3.0] - 2018-02-15

- Fix deprecation warning ([#39](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/39))
- fix for case with no s3 keys (set access via aws keypair) ([#37](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/37))

### 

* aws_iam_instance_profile.s3_readonly: "roles": [DEPRECATED] Use `role` instead. Only a single role can be passed to an IAM Instance Profile


<a name="v1.2.6"></a>
## [v1.2.6] - 2017-10-05

- Extra tags for the bastion host ([#36](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/36))


<a name="v1.2.5"></a>
## [v1.2.5] - 2017-09-26

- Fixed wrong command in README
- Fix typo ami_id => ami. ([#32](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/32))
- Add possibility to disable detailed monitoring ([#31](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/31))


<a name="v1.2.4"></a>
## [v1.2.4] - 2017-06-14

- Added possibility to specify allowed IPv6 CIDR blocks ([#30](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/30))


<a name="v1.2.3"></a>
## [v1.2.3] - 2017-06-09

- Add the ability to allow access based on security group ID ([#29](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/29))


<a name="v1.2.2"></a>
## [v1.2.2] - 2017-06-08

- Changelog
- Adding allowed_cidr var ([#28](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/28))
- Add associate address permission ([#27](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/27))
- Fixed conditional check for selinuxenabled
- adding a conditional check for selinuxenabled binary ([#23](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/23))
- Update EIP association doc ([#18](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/18))
- [re-]apply selinux labels to authorized_keys ([#17](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/17))
- fix issue where aws binary not found in PATH for S3 sync cron job ([#14](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/14))
- support setting a launch configuration key_name ([#13](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/13))
- assorted example fixes ([#11](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/11))
- fix user_data.sh on RHEL/Centos ([#12](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/12))
- Option to use instance public IP (not EIP) ([#10](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/10))
- Remove StrictHostKey checking ([#9](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/9))
- Added enabled_metrics to auto-scalling group

### 

User ubuntu

ProxyCommand ssh -o 'ForwardAgent yes' ubuntu[@bastion](https://github.com/bastion).example.com 'ssh-add && nc %h %p'
```

* Update user_data.sh

* moving stricthostkey checking disable into script

* moving outside of update_ssh_authorized_keys and added perms


<a name="v1.2.1"></a>
## [v1.2.1] - 2016-08-16

- Updated readme with example
- Updated changelog
- Updated changelog
- Support lists natively


<a name="v1.2.0"></a>
## [v1.2.0] - 2016-08-08

- Use datatype for termplate_file and minor update for compact security_groups ([#7](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/7))


<a name="v1.1.1"></a>
## [v1.1.1] - 2016-05-10

- Updated changelog
- Ensure each key is on a newline ([#6](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/6))
- Allows specifying security group ids to be added to the bastion box(es)


<a name="v1.1.0"></a>
## [v1.1.0] - 2016-04-06

- Added CHANGELOG.md
- Merge pull request [#4](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/4) from terraform-community-modules/bastion_asg
- Use autoscaling group for bastion host


<a name="v1.0.1"></a>
## [v1.0.1] - 2016-03-31

- Merge pull request [#3](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/3) from bnordbo/master
- Documentation fixes
- Allow using S3 URI too
- Fix inverted logic
- Allow key update frequency to be customized


<a name="v1.0.0"></a>
## v1.0.0 - 2016-01-12

- Merge pull request [#2](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/2) from terraform-community-modules/dynamic_keys_update
- Add crontab setup and support for additional user data script
- Merge pull request [#1](https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/issues/1) from blotto/nn_cat_keys
- append keys, do not overwrite.
- Corrected link to source in README.md
- Migrated bastion module to separate repository
- Initial commit


[Unreleased]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v2.0.0...HEAD
[v2.0.0]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.10.0...v2.0.0
[v1.10.0]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.9.0...v1.10.0
[v1.9.0]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.8.1...v1.9.0
[v1.8.1]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.8.0...v1.8.1
[v1.8.0]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.7.0...v1.8.0
[v1.7.0]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.6.0...v1.7.0
[v1.6.0]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.5.0...v1.6.0
[v1.5.0]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.3.1...v1.5.0
[v1.3.1]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.4.0...v1.3.1
[v1.4.0]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.3.0...v1.4.0
[v1.3.0]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.2.6...v1.3.0
[v1.2.6]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.2.5...v1.2.6
[v1.2.5]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.2.4...v1.2.5
[v1.2.4]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.2.3...v1.2.4
[v1.2.3]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.2.2...v1.2.3
[v1.2.2]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.2.1...v1.2.2
[v1.2.1]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.2.0...v1.2.1
[v1.2.0]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.1.1...v1.2.0
[v1.1.1]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.1.0...v1.1.1
[v1.1.0]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.0.1...v1.1.0
[v1.0.1]: https://github.com/terraform-community-modules/tf_aws_bastion_s3_keys/compare/v1.0.0...v1.0.1
