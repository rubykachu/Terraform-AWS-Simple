# Project
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

# DB
port_db                 = "5432"

# ALB
alb_health_check_path   = "/"
alb_enable_stickiness   = true
alb_stickiness_duration = 1800

