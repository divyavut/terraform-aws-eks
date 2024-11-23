locals {
    resource_name = "${var.project_name}-${var.environment}-bastion"
    bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
    # convert stringList to list , return ["subnet1", "subnet2"]
    public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
    ami_id = data.aws_ami.joindevops.id
}
