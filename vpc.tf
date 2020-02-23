resource "aws_vpc" "main" {
  cidr_block       = "${var.vpc_cidr}"
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.my_igw.id}"
  }
}

resource "aws_default_route_table" "private_route" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"
}

resource "aws_subnet" "public_subnet" {
  count                   = "${var.subnet_count}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_cidrs[count.index]}"
  map_public_ip_on_launch = true

  tags {
    Name = "My Public Subnet.${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = "${var.private_subnet_count}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.private_cidrs[count.index]}"

  tags {
    Name = "My Private Subnet.${count.index + 1}"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count           = "${aws_subnet.public_subnet.count}"
  route_table_id  = "${aws_route_table.public_route_table.id}"
  subnet_id       = "${aws_subnet.public_subnet.*.id[count.index]}"
}

resource "aws_route_table_association" "private_subnet_association" {
  count           = "${aws_subnet.private_subnet.count}"
  route_table_id  = "${aws_default_route_table.private_route.id}"
  subnet_id       = "${aws_subnet.private_subnet.*.id[count.index]}"
}

resource "aws_security_group" "alb_sg" {
  name        = "ALB HTTP"
  description = "Allow HTTP traffic to instances"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_sg" {
  name   = "Allow Web Server Traffic"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
    security_groups = ["${aws_security_group.alb_sg.id}"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name   = "Allow DB Server Traffic"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = ["${aws_security_group.web_sg.id}"]
  }
}
