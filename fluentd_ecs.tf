resource "aws_ecs_cluster" "fluentd-cluster" {
  name = "fluentd-ecs"
}

resource "aws_launch_configuration" "fluentd-ecs" {
  name_prefix          = "fluentd-ecs-launch-config-"
  image_id             = "${var.ecs_amis}"
  instance_type        = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.fluentd-ecs.name}"
  key_name             = "${var.common_key}"
  user_data            = "${data.template_file.fluentd-ecs-userdata.rendered}"
  security_groups      = ["${aws_security_group.default.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "fluentd-ecs" {
  name                      = "fluentd-ecs-sg"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.fluentd-ecs.name}"
  vpc_zone_identifier       = ["${aws_subnet.default.id}"]

  tag {
    key                 = "Name"
    value               = "${var.aws_region}-fluentd-ecs"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["desired_capacity"]
  }
}
data "template_file" "fluentd-ecs-userdata" {
  template = "${file("./cluster_ecs.sh")}"

  vars {
    cluster_name = "${aws_ecs_cluster.fluentd-cluster.name}"
  }
}

resource "aws_iam_instance_profile" "fluentd-ecs" {
  depends_on = ["aws_iam_role.fluentd-ecs"]
  name       = "${var.aws_region}-fluentd-ecs"
  role       = "${aws_iam_role.fluentd-ecs.name}"
}

resource "aws_iam_role" "fluentd-ecs" {
  name = "${var.aws_region}-fluentd-ecs"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "fluentd-ecs" {
  depends_on = ["aws_iam_role.fluentd-ecs"]
  role       = "${aws_iam_role.fluentd-ecs.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
