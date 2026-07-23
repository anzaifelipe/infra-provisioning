
## VARIÁVEIS

```hcl
prefix_name = "acm-test"                        #prefixo para indentificação do recurso
domain      = "*.devops-test.agilesvcs.com"     #Insira o nome de dominio para o certificado
zone_id     = "Z22TYESI0Z18BS"                  #Necessário pegar esta informação de um Hosted Zone já existente na AWS

tags = {
    ManagedBy       = "Terraform"
    Environment     = "dev/ragnarok"
    TerragruntPath  = path_relative_to_include()
    DateCreated     = "2022/04/27"    
}
```

## OUTPUTS

```hcl
output "domain_name" {
  description = "Domain name"
  value       = var.domain
}

output "certificate_arn" {
  description = "ARN of certificate"
  value       = aws_acm_certificate.this.arn
}
```

## OBS.

Recomendamos que o Uso de TAGS seja feita com algumas indentificações:
Gerenciado por:
Ambiente: (dev,homol,prod) e nome do projeto dentro do ambiente
TerragruntPath = path_relative_to_include() adiciona o nome da pasta que o recurso pertence
Data de criação dos recursos.

Essas tags são para aumentar a visibilidade e o gerenciamento.


Este módulo criará um certificado ACM para um nome de dominio, no entanto, é necessário já ter uma Zona Hospedada, pegue o ID desta zona e insira na variável o código irá gerar o ACM e vincular com a Hosted Zone