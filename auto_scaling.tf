# Module: https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/latest

locals {
  name_policy_cpu = "ASGAverageCPUUtilization"
}

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

# Policy scale up
resource "aws_autoscaling_policy" "ec2_scale_up" {
  name                      = local.name_policy_cpu
  autoscaling_group_name    = module.asg.this_autoscaling_group_name
  adjustment_type           = "ChangeInCapacity"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = local.name_policy_cpu
    }

    target_value = 80.0
  }
}
