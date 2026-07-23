terraform { 
  backend "s3" { 
    # coloque o nome do bucket abaixo! 
    bucket         = "agiletv-devops-terraform-files" 
    key            = "backstage/mib/${{ values.project }}/${{ values.environment }}/terraform.tfstate" 
    region         = "eu-west-1" 
    encrypt        = true 
  } 
} 

provider "aws" {
  region  = "us-east-1"
}

module "sg_rds" {
    source                      = "../../module_sg"

    prefix_name                 = "${local.common_tags.Project}-teste-${local.common_tags.Environment}"  
    security_group_name         = "${local.common_tags.Project}-teste-${local.common_tags.Environment}"
    security_group_description  = "allow service ports access"
    vpc_id                      = "vpc-054f59d8889ab08c1"

    security_group_rules       = {
        rule01 = {
            description = "Allow SQL VPC Access"
            direction   = "ingress"
            protocol    = "tcp"
            from_port   = 1433
            to_port     = 1433
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = ["172.28.0.0/22"]
            }
        },
        rule02 = {
            description = "HTTP allow egress"
            direction   = "egress"
            protocol    = "-1"
            from_port   = 0
            to_port     = 0
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = ["0.0.0.0/0"]
            }
        },        
        rule03 = {
            description = "Allow Agile Office SP primary"
            direction   = "ingress"
            protocol    = "tcp"
            from_port   = 1433
            to_port     = 1433
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = ["189.39.44.68/32"]
            }
        },        
        rule04 = {
            description = "Allow Agile Office SP secondary"
            direction   = "ingress"
            protocol    = "tcp"
            from_port   = 1433
            to_port     = 1433
            addresses   = {
            type        = "cidr_blocks"
            cidr_blocks = ["201.6.159.217/32"]
            }
        },
    }

  tags = merge(local.common_tags, {
  })

}