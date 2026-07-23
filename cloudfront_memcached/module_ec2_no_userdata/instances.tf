data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values =  ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

resource "aws_instance" "stack" {
  ami                    = data.aws_ami.amazon-2.id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  subnet_id              = var.subnet
  vpc_security_group_ids = ["${var.ec2_sg}"]
  iam_instance_profile   = var.create_role ? aws_iam_instance_profile.ec2_profile[0].name : null
  root_block_device {
    volume_size = var.volume_size
  }
 # user_data = data.template_file.script.rendered
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
  instance_id   = aws_instance.stack.id
  allocation_id = aws_eip.ec2-eip.id
}
