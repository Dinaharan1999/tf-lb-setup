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

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

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


resource "aws_iam_role" "ec2_ssm_role" {

  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-ec2-role"
    }
  )
}



resource "aws_iam_role_policy_attachment" "ssm" {

  role = aws_iam_role.ec2_ssm_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}


resource "aws_iam_instance_profile" "ec2_profile" {

  name = "${var.project_name}-instance-profile"

  role = aws_iam_role.ec2_ssm_role.name

}

