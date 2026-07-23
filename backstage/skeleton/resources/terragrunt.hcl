remote_state {
    backend = "s3"

    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }

    config = {
        bucket =  "devops-agiletv-terraform" #Insert here the bucket for tfstate file
        key = "TESTE/backstage/${path_relative_to_include()}/terraform.tfstate"
        region = "us-east-1"
        encrypt = true
    }
}

generate "provider" {
    path      = "provider.tf"
    if_exists = "overwrite" #make sure to edit the region and profile to deploy all mib services
    contents = <<EOF
        provider "aws" {
            region      = "eu-west-1"
        }
    EOF
}

terraform  {
    extra_arguments "variable" {
        commands = get_terraform_commands_that_need_vars()
    }
}