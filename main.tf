provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "SG_ELB" {
  vpc_id = "${var.vpc-id}"

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "terra_elb_sg"
  }
}
resource "aws_security_group" "SG_EC2" {
  vpc_id = "${var.vpc-id}"

  ingress {
    description = "ssh port"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.admin-cidr}"]
  }
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_groups = ["${aws_security_group.SG_ELB.id}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "terra_ec2_sg"
  }
}

resource "aws_elb" "ELB" {
  subnets         = ["${var.subnet-id}"]
  security_groups = ["${aws_security_group.SG_ELB.id}"]
  instances = ["${aws_instance.EC2_instance.id}"]

  listener {
    instance_port     = "80"
    instance_protocol = "HTTP"
    lb_port           = "80"
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/index.php"
    interval            = 6
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 4
  }
  tags {
    Name = "terra_elb"
  }
}
resource "aws_instance" "EC2_instance" {
  ami = "${var.instance-ami}"
  instance_type = "t2.micro"
  subnet_id = "${var.subnet-id}"
  vpc_security_group_ids = ["${aws_security_group.SG_EC2.id}"]
  user_data = "${file("userdata.sh")}"
  tags {
    Name = "terra_EC2_ins"
  }
}
