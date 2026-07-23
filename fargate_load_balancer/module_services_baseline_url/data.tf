data "aws_region" "current_region" {}           # Find region, e.g. us-east-1
data "aws_caller_identity" "current_account" {} # Find account ID, e.g. 198451936645

data "aws_iam_policy_document" "task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

#data "template_file" "service-ecs" {
#  template = file("./templates/services.json")

#  vars = {
#    name = var.ecs_name
#    image_ecr_url = var.image_ecr_url
#    image_tag      = var.image_tag
#    container_cpu  = var.container_cpu
#    container_mem    = var.container_mem
#    task_environment_variables = var.task_environment_variables == [] ? null : var.task_environment_variables
#    task_secret_environment_variables = var.task_secret_environment_variables == [] ? null : [var.task_secret_environment_variables]
#    current_region     = data.aws_region.current_region.name
#    app_port = var.app_port
#  }
#}