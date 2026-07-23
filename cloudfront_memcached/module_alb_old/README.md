## VARIÁVEIS

```hcl
name                            = "ecs-alb"                 #Nome do recurso
prefix_name                     = "teste-lb"                #prefixo para identificação do recurso
internal_flag                   = false                     #Load balancer apenas interno ou com acesso externo, falso permite conexão externa
enable_deletion_protection_flag = false                     #Proteção para evitar deletar o recurso sem querer 
security_group_id               = [ dependency.sg.outputs.security_group_id ]      
vpc_id                          = dependency.vpc.outputs.vpc_id     
health_path                     = "/"                       #Caminho do Health Check no target group
listener_port                   = 443                       #Porta usada depois do redirect da porta 80 para...
listener_protocol               = "HTTPS"                   #Protocolo usado depois do redrect http para...
listener_policy                 = "ELBSecurityPolicy-2016-08"       #Policy SSL depois do redirect
certificate_arn                 = dependency.acm.outputs.certificate_arn     
subnets                         = dependency.vpc.outputs.public_subnets        
tags = {          
    ManagedBy       = "Terraform"
    Environment     = "dev/ragnarok"
    TerragruntPath  = path_relative_to_include()
    DateCreated     = "2022/04/27"    
}
```

## OUTPUTS

 ```hcl
output "alb_name" {
  description = "Name of load balancer"
  value       = var.name
}

output "alb_arn" {
  description = "ARN of Application Load Balancer"
  value       = aws_lb.this.arn
}

output "alb_listener_arn" {
  description = "ARN of Application Load Balancer Listener"
  value       = aws_lb_listener.custom_listener.arn
}

output "alb_zone_id" {
  description = "Zone ID of Application Load balancer"
  value       = aws_lb.this.zone_id
}

output "alb_dns_name" {
  description = "DNS name of Application Load balancer"
  value       = aws_lb.this.dns_name
}

output "target-group" {
  description = "Target group name"
  value       = aws_lb_target_group.target-group.arn
}
```

## OBS.

Recomendamos que o Uso de TAGS seja feita com algumas indentificações:
Gerenciado por:
Ambiente: (dev,homol,prod) e nome do projeto dentro do ambiente
TerragruntPath = path_relative_to_include() adiciona o nome da pasta que o recurso pertence
Data de criação dos recursos.

Essas tags são para aumentar a visibilidade e o gerenciamento.


Este módulo depende de diversos outros como VPC, SG e ACM para funcionar.
Ao criar um cluster, existirá uma regra que redirecionará todos os acessos 80 para uma porta selecionada em 'listener_port', segurimos sempre usar a 443 com segurança e tambem com um certificado acm gerado.

O target group também será criado, neste contexto haverá sempre um novo target group para cada recurso