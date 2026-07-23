## VARIÁVEIS

```hcl
vpc_id                      = dependency.vpc.outputs.vpc_id                     #Dependencia direta do módulo VPC
public_subnets              = [  dependency.vpc.outputs.public_subnets ]        #Dependencia direta do módulo VPC
private_subnets             = [ dependency.vpc.outputs.private_subnets ]        #Dependencia direta do módulo VPC
security_group_id           = dependency.sg.outputs.security_group_id           #Dependencia direta do módulo SG
prefix_name                 = "terragrunt"                                      #prefixo para identificação dos recursos
is_public                   = true                                              #Vai definir qual subnet usar se publica ou privada
autoScale_daytime           = false                                             #Escala para funcionar somente de SEG-SEX dàs 7h-19h
autoScale_resource_usage    = true                                 #Escala baseado no uso do recurso, acima de 85% sobe mais uma, abaixo de 10% diminiu uma
fargate_cpu                 = 1024                                 #CPU do cluster
fargate_mem                 = 2048                                 #MEM do cluster
container_cpu               = 1024                                 #CPU do container
container_mem               = 2048                                 #MEM do container
ecs_name                    = "nginx_cluster_teste"                #Nome do cluster
image_ecr_url               = "nginx"                              #URL da imagem
image_tag                   = "latest"                             #Versão da imagem
target_group_arn            = dependency.alb.outputs.target-group  #Dependencia direta do módulo ALB 
task_environment_variables  = [                                    #lista de variaves de ambiente
 #       { name : "ENV1", value : "env_value1" }, 
 #       { name : "ENV2", value : "env_value2" }
    ]
task_secret_environment_variables = [                              #Lista para ser usada com secret manager, como senhas e usuarios
#        { name : "SECRET", valueFrom : "secrets_manager_secret_arn" } 
    ]
execution_iam_access = {                                           #caso queira uma execution role diferente no cluster, não é necessário alterar
    secrets = [
#        "secrets_manager_secret_arn" # 
    ]
    kms_cmk = [
#        data.aws_secretsmanager_secret.kms_cmk_arn.kms_key_id 
    ]
    s3_buckets = [
#        "s3_bucket_arn" 
    ]
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
output "ecs_cluster_id" {
  description = "ID of the ECS Cluster"
  value       = aws_ecs_cluster.fargate_cluster.id
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS Cluster"
  value       = aws_ecs_cluster.fargate_cluster.arn
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = var.ecs_name
}
```

## OBS.

Recomendamos que o Uso de TAGS seja feita com algumas indentificações:
Gerenciado por:
Ambiente: (dev,homol,prod) e nome do projeto dentro do ambiente
TerragruntPath = path_relative_to_include() adiciona o nome da pasta que o recurso pertence
Data de criação dos recursos.

Essas tags são para aumentar a visibilidade e o gerenciamento.

EXECUTE ESTE MÓDULO SOMENTE APÓS EXECUTAR O MÓDULO ALB
Garanta que os valores de CPU e MEM do cluster, não ultrapassem os valores do container