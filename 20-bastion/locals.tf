locals {
    resource_name = "${var.project_name}-${var.environment}-bastion"
    bastion_sg_id = data.aws_ssm_parameter.import_bastion_sg_id.value
    # convert stringList to list , return ["subnet1", "subnet2"]
    public_subnet_ids = split(",", data.aws_ssm_parameter.import_public_subnet_ids.value)[0]
    ami_id = data.aws_ami.joindevops.id
}
