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
  value = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTyTnnDjq8ZxRJAvsLShh0FGnEeLCjrE+KDdCGsfek7NkaNVKCFrRGkTf2XhSj/gRWUIvJzYC8V6qFKv/xPAmk9ReDLP4PvR+x5TRVmPy4ZQO23ruJwvbc5BVyz1S3Z/2xHMKKhhOGlYPniJ0wr0VWqc6dMPfSMPfmkNjjAkGh/9el9soO7aOfXO6uWFBv2yCyDG7p+0MhM6tgB0f6C40ikly4P0uu1F9fpf0SaBWkgctUpkbhoCp+IAEYY/oNMA7btSRkllj9cLUevIfIu4dCvV8Ba4OYYGfJSAz/CVw3DeaMFcwJv9+fIp2DCCnuAy0ZZ8Lbd7pNK2/IJIsJbdwoSkjd5M7XmTWZPDgEuqcjtMJxlEe1ivgVXxHOEHd8eV7sdxwi6m22DmCkTmrp8uDYpGMX3JeqLCToasINA4CJS/dZ/2NqZ/F0YTy4MRGHiiKeIpU127G0c1/y3LoLYr0mGiQzkQEXm9RHHW56JLI0qAc6YaBX1jMseoOfHC/AyQ8 = apple@MinhTangs-MacBook-Pro.local"
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
