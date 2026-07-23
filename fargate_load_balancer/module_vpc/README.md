Um dos módulos mais importantes, senão o mais importante.
Este módulo é responsável por permitir ou não conexões entre recurso e com o mundo externo.
## VARIÁVEIS

```hcl
 vpc_cidr                   = "192.40.0.0/16"  	    #tenha certeza de não ter outro CIDR igual
 prefix_name                = "terragrunt" 	        #indentificação inseira antes de todos os recursos
 sufix_name                 = "test"			    #alguns recursos usam para auxiliar na indentificação
 azs                        = ["uswest2a", "uswest2b", "uswest2c"]	    #recomendamos colocar mais de 1 zona de disponibilidade
 public_subnets             = ["192.40.1.0/24", "192.40.2.0/24"]		#Redes publicas 
 private_subnets            = ["192.40.100.0/24", "192.40.101.0/24"]	#Redes privadas
 enable_external_access     = true  		        #Libera ou não acesso externo para a rota da vincula à VPC
 enbale_private_to_internet = false	                #Libera rede privada para sair para internet, não recebe entrada de qualquer forma.

 tags = {
    ManagedBy       = "Terraform"
    Environment     = "dev/ragnarok"
    TerragruntPath  = path_relative_to_include()
    DateCreated     = "2022/04/27"    
}
```

## OUTPUTS

```hcl
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "igw_id" {
  value = try(aws_internet_gateway.igw-vpc[0].id, "")
}

output "route_table_vpc_id" {
  value = try(aws_route_table.route-table-vpc[0].id, "")
}

output "route_table_public_id" {
  value = try(aws_route_table.route-table-public[0].id, "")
}

output "route_table_private_id" {
  value = try(aws_route_table.route-table-private[0].id, "")
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "eip-nat" {
  description = "Eip used to allow internet access for private subnet"
  value       = try(aws_eip.eip-nat[0].id, "")
}
```

## OBS.

Recomendamos que o Uso de TAGS seja feita com algumas indentificações:
Gerenciado por:
Ambiente: (dev,homol,prod) e nome do projeto dentro do ambiente
TerragruntPath = path_relative_to_include()  adiciona o nome da pasta que o recurso pertence
Data de criação dos recursos.

Essas tags são para aumentar a visibilidade e o gerenciamento.


Neste módulo, quando houver diversas subnets e AZs, o módulo inserirá automaticamente a subnet na AZ seguinte.