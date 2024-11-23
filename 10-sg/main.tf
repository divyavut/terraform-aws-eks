# create Ingress controller security group
module "ingress_alb_sg" {
    source = "git::https://github.com/divyavut/terraform-aws-sg.git?ref=main"
    sg_name = "ingress-alb"
    project_name = var.project_name
    environment = var.environment
    vpc_id = local.vpc_id
}
# create node group security group
module "node_sg" {
    source = "git::https://github.com/divyavut/terraform-aws-sg.git?ref=main"
    sg_name = "node"
    project_name = var.project_name
    environment = var.environment
    vpc_id = local.vpc_id
}
# create EKS control plane security group
module "eks_control_plane_sg" {
    source = "git::https://github.com/divyavut/terraform-aws-sg.git?ref=main"
    sg_name = "eks-control-plane"
    project_name = var.project_name
    environment = var.environment
    vpc_id = local.vpc_id
}
# create mysql security group
module "mysql_sg" {
    source = "git::https://github.com/divyavut/terraform-aws-sg.git?ref=main"
    sg_name = "mysql"
    project_name = var.project_name
    environment = var.environment
    vpc_id = local.vpc_id

}
# create bastion security group
module "bastion_sg" {
    source = "git::https://github.com/divyavut/terraform-aws-sg.git?ref=main"
    sg_name = "bastion"
    project_name = var.project_name
    environment = var.environment
    vpc_id = local.vpc_id
}

# ingress alb allows traffic on port 443 from internet_user
resource "aws_security_group_rule" "ingress_alb_internet_user" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ingress_alb_sg.id 
}
# node allows  traffic on port (30000 to 32767) from ingress alb
resource "aws_security_group_rule" "node_ingress_alb" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  source_security_group_id = module.ingress_alb_sg.id
  security_group_id = module.node_sg.id 
}
# node allow all traffic and all port from eks control plane
resource "aws_security_group_rule" "node_eks_control_plane" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.eks_control_plane_sg.id
  security_group_id = module.node_sg.id 
}
# eks control plane allow all traffic and all port from node
resource "aws_security_group_rule" "eks_control_plane_node" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = module.node_sg.id
  security_group_id = module.eks_control_plane_sg.id 
}
# eks control plane allow traffic on port 443 from bastion
resource "aws_security_group_rule" "eks_control_plane_bastion" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id = module.eks_control_plane_sg.id
}
# node allows traffic on port 22 from bastion
resource "aws_security_group_rule" "node_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id = module.node_sg.id 
}
# node1 allows all traffic and all port from node2 (vice versa)
resource "aws_security_group_rule" "node_node" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = module.node_sg.id 
}

# mysql allows  traffic and on port 22 from bastion (vice versa)
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id = module.mysql_sg.id 
}
# bastion allows  traffic and on port 22 from public
resource "aws_security_group_rule" "bastion_internet_user" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.id 
}