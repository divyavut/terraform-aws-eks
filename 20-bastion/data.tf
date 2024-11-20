data "aws_ssm_parameter" "import_bastion_sg_id" {
    # /expense/dev/bastion_sg_id
name  = "/${var.project_name}/${var.environment}/bastion_sg_id"
}

# Terraform uses list(String) defined as ["subnet1", "subnet2"], AWS uses StringList defined as "subnet1,subnet2".
# To convert StringList to list(String), we use split(",", "foo,bar,baz") function
data "aws_ssm_parameter" "import_public_subnet_ids" {
name  = "/${var.project_name}/${var.environment}/public_subnet_ids"
}

data "aws_ami" "joindevops" {
  owners           = ["973714476881"]
  most_recent      = true
  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}