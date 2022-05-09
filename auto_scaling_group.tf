# default vpc가 있어야함
resource "aws_autoscaling_group" "group" {

  name = "terraform-web-auto-group"
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.terraform_public_1.id, aws_subnet.terraform_public_2.id]
  target_group_arns   = [aws_lb_target_group.group.arn]
  launch_template {
    id      = "${aws_launch_template.terraform_template.id}"
    version = "$Latest"
  }
}

# sns 연결
resource "aws_autoscaling_notification" "example_notifications" {
  group_names = [
    aws_autoscaling_group.group.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = "arn:aws:sns:ap-northeast-2:485879423137:autocaling-watch"
}