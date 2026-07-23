data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    #values = ["amzn2-ami-hvm-*-x86_64-ebs"]
    values = ["al2023-ami-2023*-x86_64"]
  }
  owners = ["amazon"]
}


data "aws_secretsmanager_secret_version" "creds" {
  secret_id = var.creds_name
}

data "template_file" "script" {
  template = file("${path.module}/monitor-stack.sh")
  #  template = "${file("router-init.sh.tpl")}"

  vars = {
    access_key     = "${local.grafanaMonitor.accessKey}"
    secret_key     = "${local.grafanaMonitor.secretKey}"
    git_token      = "${local.grafanaMonitor.gitToken}"
#    access_key     = "${var.access_key}"
#    secret_key     = "${var.secret_key}"
#    git_token      = "${var.git_token}"
    git_username   = "${var.git_username}"
    aws_region     = "${var.aws_region}"
    caddy_user     = "${var.caddy_user}"
    caddy_password = "${var.caddy_password}"
    domain         = "${var.domain}"
  }
}

resource "aws_instance" "monitor-stack" {
  ami                    = data.aws_ami.amazon-2.id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  subnet_id              = var.subnet_first
  vpc_security_group_ids = ["${var.monitor_sg}"]
  root_block_device {
    volume_size = var.volume_size
  }
  user_data = data.template_file.script.rendered
  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}"
      )
    },
    var.tags,
  )
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.monitor-stack.id
  allocation_id = aws_eip.monitor-eip.id
}
