data "template_file" "user_data" {
  template = "${file("user_data.sh")}"
  vars { }
}

resource "aws_launch_configuration" "web" {
  name_prefix      = "web-server"
  image_id         = "${var.ami}"
  instance_type    = "${var.instance_type}"
  key_name         = "${var.key_name}"

  security_groups  = ["${aws_security_group.web_sg.id}"]
  user_data        = "${data.template_file.user_data.rendered}"

  lifecycle        {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web-asg" {
  name                 = "My_Web_ASG"
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  health_check_type    = "ELB"
  target_group_arns    = ["${aws_lb_target_group.alb_target_group.arn}"]
  launch_configuration = "${aws_launch_configuration.web.name}"
  vpc_zone_identifier  = ["${aws_subnet.private_subnet.*.id}"]
}
