 locals  {
    tags = {
        ManagedBy       = "Terraform-Terragrunt"
        Environment     = "stag"
        Owner           = ""
        Project         = ""
        DateCreated     = "2025-10-30"
    }

    keypair = {
        key = ""
    }

    domain = {
        domain_id   = ""
        domain_name = ""
    }

    ec2 = {
        access_key      = ""
        secret_key      = ""
        git_username    = ""
        git_token       = ""
        creds_name      = ""
        caddy_user      = ""
        caddy_password  = ""
    }
 }
