## VARIÁVEIS

```hcl
 zone_id            = "Z22TYESI0Z18BS"       #Insira o id da hosted zone aqui, deve-se pegar da AWS
 dns_alias_records  = {                      #Informações para cadastro do nome de dominio 
    rule01 = {
        name                = "app.devopstest.agilesvcs.com"
        type                = "A"
        alias_name          = dependency.alb.outputs.alb_dns_name,    
        alias_zone_id       = dependency.alb.outputs.alb_zone_id,
        alias_target_health = true
    }
}
```

## OUTPUTS

```hcl
output "zone_id" {
    value = var.zone_id
    description = "ID of Route53 zone"
}

output "dns_records" {
    value = var.dns_records
    description = "DNS records"
}

output "dns_alias_records" {
    value = var.dns_alias_records
    description = "DNS alias records"
}
```

## OBS.

Este módulo não usa TAGS

Ao usar um nome, lembrese de selecionar um que seja compativel com o certificdo ACM para não gerar problemas.
Este exemplo o módulo está usando uma depencia direta do módulo ALB, mas não é uma obrigação