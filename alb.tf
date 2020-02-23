resource "aws_lb" "alb" {
  name               = "${var.alb_name}"
  load_balancer_type = "application"
  subnets            = ["${aws_subnet.public_subnet.*.id}"]
  security_groups    = ["${aws_security_group.alb_sg.id}"]
  internal           = false
}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "${var.target_group}"
  port     = "${var.svc_port}"
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "${var.lb_listener_port}"
  protocol          = "${var.lb_listener_protocol}"

  default_action {
    target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
    type             = "forward"
  }
}
