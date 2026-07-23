
## VARIÁVEIS

```hcl
 security_group_name        = "customsg"                        #nome da SG
 security_group_description = "allow http"                      #descrição do SG
 vpc_id                     = dependency.vpc.outputs.vpc_id     #Depende do módulo de VPC
 prefix_name                = "terragrunt"                      #prefixo para identificação do recurso

 security_group_rules = {                                       #regras de entrada e saída do SG, 
    rule01 = {
        description = "HTTP allow ingress"
        direction   = "ingress"
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        addresses   = {
        type        = "cidr_blocks"
        cidr_blocks = ["0.0.0.0/0"]
        }
    },
    rule02 = {
        description = "HTTP allow egress"
        direction   = "egress"
        protocol    = "1"
        from_port   = 0
        to_port     = 0
        addresses   = {
        type        = "cidr_blocks"
        cidr_blocks = ["0.0.0.0/0"]
        }
    }
}

tags = {
    ManagedBy       = "Terraform"
    Environment     = "dev/ragnarok"
    TerragruntPath  = path_relative_to_include()
    DateCreated     = "2022/04/27"        
}
```

## OUTPUTS
```hcl
output "security_group_name" {
  description = "Name of Security Group"
  value       = var.security_group_name
}

output "security_group_id" {
  description = "ID of Security Group"
  value       = aws_security_group.sg-custom.id
}

output "security_group_vpc_id" {
  description = "VPC of Security Group"
  value       = var.vpc_id
}
```

## OBS.

Recomendamos que o Uso de TAGS seja feita com algumas indentificações:
Gerenciado por:
Ambiente: (dev,homol,prod) e nome do projeto dentro do ambiente
TerragruntPath = path_relative_to_include()  adiciona o nome da pasta que o recurso pertence
Data de criação dos recursos.

Essas tags são para aumentar a visibilidade e o gerenciamento.


Neste módulo, Caso seja necessário a criação de mais de uma entrada, copie o bloco da regra e faça os ajustes necessáios:
    rule03 = {
        description = "HTTPS allow ingress"
        direction   = "ingress"
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        addresses   = {
        type        = "cidr_blocks"
        cidr_blocks = ["0.0.0.0/0"]
        }
    }

Não é necessário manter o nome: rule03, rule04, rule05...
