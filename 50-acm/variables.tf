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


variable "zone_name" {
    default = "dev.divyavutakanti.com"
}

variable "zone_id" {
    default = "Z0893880YX0SRBJLZSWX"
}
