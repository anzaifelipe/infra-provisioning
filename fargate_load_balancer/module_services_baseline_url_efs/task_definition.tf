# Task definition
# Will be relaunched by service frequently
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.service_name
  execution_role_arn       = aws_iam_role.ExecutionRole.arn
  task_role_arn            = var.enable_exec ? aws_iam_role.ExecutionRole.arn : var.task_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  # Fargate cpu/mem must match available options: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  cpu    = var.fargate_cpu
  memory = var.fargate_mem

  ephemeral_storage {
    size_in_gib = var.size_disk
  }

  volume {
    name = var.volume_name

    efs_volume_configuration {
      file_system_id     = var.efs_id
      root_directory     = var.root_directory
      transit_encryption = var.encryption

      dynamic "authorization_config" {
        for_each = var.access_point_id != null ? [1] : []
        content {
          access_point_id = var.access_point_id
          iam             = "ENABLED"
        }
      }
    }
  }

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
        ulimits = [
          {
            name      = "nofile"
            softLimit = var.softLimit
            hardLimit = var.hardLimit
          }
        ]
        mountPoints = [
          {
            sourceVolume  = var.volume_name
            containerPath = var.container_path
            readOnly      = var.read_only
          }
        ]
        networkMode = "awsvpc"
        logConfiguration = {
          logDriver = "awslogs",
          options = {
            awslogs-group = "/ecs/${var.service_name}-LogGroup",
            awslogs-region : "${data.aws_region.current_region.name}",
            awslogs-stream-prefix : "${var.service_name}"
          }
        }
        portMappings = "${var.port_mapping}"
#       portMappings : [{
#          containerPort : "${var.container_port}",
#          hostPort : "${var.container_port}"
#        }]
      }
    ]
  )

  tags = {
    Name = "${var.service_name}"
  }
}