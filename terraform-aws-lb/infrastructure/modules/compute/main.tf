###############################################################
# Latest Amazon Linux 2023
###############################################################

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

###############################################################
# EC2 Instances
###############################################################

resource "aws_instance" "web" {

  count = 2

  ami = data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  subnet_id = var.subnet_ids[count.index]

  vpc_security_group_ids = [var.web_sg]

  key_name = var.key_name != "" ? var.key_name : null

  associate_public_ip_address = true

  user_data = file("${path.root}/user-data/nginx.sh")

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-web-${count.index + 1}"
      Role = "WebServer"
    }
  )

  lifecycle {
    create_before_destroy = true
  }

}