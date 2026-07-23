data "aws_ami" "instance" {
  most_recent = true

  filter {
    name   = "name"
    #values = ["amzn2-ami-hvm-*-x86_64-ebs"]
    #values = ["al2023-ami-2023*-x86_64"]
    values = ["*ubuntu-noble-24.04-amd64-server-*"]
  }
  owners = ["amazon"]
}

data "template_file" "script" {
  template = file("${path.module}/userdata.sh")
  #  template = "${file("router-init.sh.tpl")}"

  vars = {
    domain = "${var.domain}"
    passdb = "${var.passdb}"
  }
}

resource "aws_instance" "instance-stack" {
  ami                    = data.aws_ami.instance.id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  subnet_id              = var.subnet
  vpc_security_group_ids = [aws_security_group.sg-custom.id]
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
  instance_id   = aws_instance.instance-stack.id
  allocation_id = aws_eip.instance-eip.id
}
