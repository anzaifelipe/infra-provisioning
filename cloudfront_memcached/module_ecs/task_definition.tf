# Task definition
# Will be relaunched by service frequently
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.ecs_name
  execution_role_arn       = aws_iam_role.ExecutionRole.arn
  task_role_arn            = var.task_role_arn == null ? null : var.task_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  # Fargate cpu/mem must match available options: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
  cpu    = var.fargate_cpu
  memory = var.fargate_mem
  container_definitions = jsonencode(
    [
      {
        name      = "${var.ecs_name}"
        image     = "${var.image_ecr_url}:${var.image_tag}"
        cpu       = "${var.container_cpu}"
        memory    = "${var.container_mem}"
        essential = true
        #        environment = "${var.task_environment_variables}"
        #        secrets     = var.task_secret_environment_variables == [] ? null : [var.task_secret_environment_variables]
        logConfiguration : {
          logDriver : "awslogs",
          options : {
            awslogs-group : "${var.ecs_name}LogGroup",
            awslogs-region : "${data.aws_region.current_region.name}",
            awslogs-stream-prefix : "${var.ecs_name}"
          }
        }
      }
    ]
  )

  tags = {
    Name = "${var.ecs_name}"
  }
}