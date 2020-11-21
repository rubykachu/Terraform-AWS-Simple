# Module: https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/latest

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "3.7.0"

  # Name of instance when create by ASG
  name = "asg-${var.project_code}-web-${terraform.workspace}"

  # Launch configuration
  lc_name         = "ASG-configuration-webserver"
  image_id        = var.asg_ami_id
  key_name        = var.asg_name_keypair
  instance_type   = var.asg_instance_type
  security_groups = [aws_security_group.sg_webserver.id]

  root_block_device = var.asg_ebs_root_instance

  # Auto scaling group
  asg_name                  = "ASG-webserver"
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = "ELB"
  min_size                  = 1
  max_size                  = 4
  desired_capacity          = 2
  wait_for_capacity_timeout = 0

  # Attach Load Balancer
  target_group_arns = [aws_lb_target_group.webserver.arn]

  tags = [
    {
      key                 = "Stages"
      value               = terraform.workspace
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = var.project
      propagate_at_launch = true
    },
    {
      key                 = "Terraform"
      value               = true
      propagate_at_launch = true
    }
  ]
}

# Ref: https://testable.io/create-an-aws-auto-scaling-group-with-terraform/

# Policy scale-out (add more instances)
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "ScaleOut-MemoryUtilization"
  autoscaling_group_name = module.asg.this_autoscaling_group_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
}

# Policy scale-in (run fewer instances)
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "ScaleIn-MemoryUtilization"
  autoscaling_group_name = module.asg.this_autoscaling_group_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
}

resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "MemoryUtil-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"
  alarm_description   = "This metric monitors ec2 memory for high utilization on agent hosts"
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]
  dimensions = {
    AutoScalingGroupName = module.asg.this_autoscaling_group_name
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_low" {
  alarm_name          = "MemoryUtil-Low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "20"
  alarm_description   = "This metric monitors ec2 memory for low utilization on agent hosts"
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]
  dimensions = {
    AutoScalingGroupName = module.asg.this_autoscaling_group_name
  }
}

