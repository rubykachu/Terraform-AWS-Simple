# Project
workspaces              = ["dev", "prd"]
profile                 = "learning"
project                 = "example"
project_code            = "exm"

# VPC
region                  = "us-east-1"
cidr_block              = "10.0.0.0/16"

# Subnets
azs                     = ["us-east-1a", "us-east-1b"]
private_subnets         = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets          = ["10.0.101.0/24", "10.0.102.0/24"]

# EC2
keypair = {
  name = "MKP-exm-dev"
  value = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCcigTkMwEWqKTIJVtO13OdLM2S9rB79g8vmVS7jEvH2lheiwDg92bHzmZV1LRdVId1pjmri6IYNrq0FYkbh9nUOn7gvZhfxl1lsxY6ZYJLM4Vn9uJ7YNQbnyQi7q9l5YwIMpz+uzD6J+naKw8OTHJSw+oQ8HkmiP8Qs/g9udC+dGLW0XVoOKHfHTJ3Qge+ZN8VyElFz1EzdZ8yYPCy4Lw+1Lb+6YP/oqtAe7YcFJ0X/NfnJ8KPGkZv0D92F3VOE0zQPs+kyh4zT2tHAisRDTqBEiAty6+B8y/JGCSyWmhnFEtzD2fnG+VfGIHPTjc+Z5K1nDyaB+VFvnlz0dsXJog4dAWvb4CmzdDJueBajkeMI8YXAubMPuQcxqbgNCuVSa09ERPOjm7uGWi+rNfkVCieirW6NGQk3GL4hF+UiWGAXF8VZ8SLp3oEPkvogdPmR8ph49QveZ82bIwey8eXgX2V/TMU0yPdUvCJJ6DtF5VNtFPs7gRQr0Z91lbICbQ5H3M= apple@MinhTangs-MBP"
}

# DB
port_db                 = "5432"

# ALB
alb_health_check_path   = "/"
alb_enable_stickiness   = true
alb_stickiness_duration = 1800

# ASG
asg_ami_id              = "ami-0f1a5142758f85483"
asg_instance_type       = "t2.micro"
asg_name_keypair        = "MKP-exm-dev"
