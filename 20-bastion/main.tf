module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami =                     local.ami_id
  name = local.resource_name
  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id              = local.public_subnet_ids
 
  tags = {
        Name = local.resource_name
  }
}