locals {
    resource_name = "${var.project_name}-${var.environment}-bastion"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    # convert stringList to list , return ["subnet1", "subnet2"]
    private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
    eks_control_plane_sg_id = data.aws_ssm_parameter.eks_control_plane_sg_id.value
    node_sg_id = data.aws_ssm_parameter.node_sg_id.value
    ami_id = data.aws_ami.joindevops.id 
}
