# Task definition
# Will be relaunched by service frequently
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.service_name
  execution_role_arn       = aws_iam_role.ExecutionRole.arn
 # task_role_arn            = var.task_role_arn == null ? null : var.task_role_arn
  task_role_arn            = aws_iam_role.ExecutionRole.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  # Fargate cpu/mem must match available options: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  cpu    = var.fargate_cpu
  memory = var.fargate_mem
  
  runtime_platform { 
          cpu_architecture        = var.cpu_architecture
          operating_system_family = var.operating_system_family
        }

  container_definitions = jsonencode(
    [
      {
        name      = "${var.service_name}"
        image     = "${var.image_ecr_url}:${var.image_tag}"
        cpu       = "${var.container_cpu}"
        memory    = "${var.container_mem}"
        essential = true
        readonlyRootFilesystem = "${var.readonly_filesystem}"
        environment = "${var.task_environment_variables}"
        
         ulimits : [
          {
            name : "nofile",
            softLimit : "${var.softLimit}"
            hardLimit : "${var.hardLimit}"
          }
        ]
        networkMode : "awsvpc"        
        logConfiguration : {
          logDriver : "awslogs",
          options : {
            awslogs-group : "/ecs/${var.service_name}-LogGroup",
            awslogs-region : "${data.aws_region.current_region.name}",
            awslogs-stream-prefix : "${var.service_name}"
          }
        }
        portMappings = "${var.port_mapping}"
      },
      {
        name      = "${var.service_name_second}"
        image     = "${var.image_ecr_url_container_second}:${var.image_tag_container_second}"
        cpu       = "${var.container_second_cpu}"
        memory    = "${var.container_second_mem}"
        essential = false
        environment = "${var.container_second_environment_variables}"
#        repositoryCredentials = {
#          credentialsParameter = "${var.secrets_manager_arn}"
#        }
        readonlyRootFilesystem = "${var.readonly_filesystem}"
        ulimits = [
          {
            name : "nofile",
            softLimit : "${var.softLimit}"
            hardLimit : "${var.hardLimit}"
          }
        ]
        networkMode : "awsvpc"   
        logConfiguration = {          
          logDriver : "awslogs",
          options : {
            awslogs-group : "/ecs/${var.service_name_second}-LogGroup",
            awslogs-region : "${data.aws_region.current_region.name}",
            awslogs-stream-prefix : "${var.service_name_second}-container2"
          }
        }
        portMappings = "${var.container2_port_mapping}"
      }
    ]
  )

  tags = {
    Name = "${var.service_name}"
  }
}