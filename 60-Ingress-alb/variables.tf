variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Terraform = "true"
        Environment = "dev"
    }
}

variable "ingress_alb_tags" {
    default = {
        Component = "ingress_alb"
    }
}


variable "zone_name" {
    default = "divyavutakanti.com"
}