# Project
variable "profile" {
  description = "Profile credentials AWS"
  type        = string
}

variable "project" {
  description = "Name of project"
  type        = string
}

variable "project_code" {
  description = "Code of project"
  type        = string
}

# VPC
variable "region" {
  description = "Region build AWS"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
}

# Subnets
variable "azs" {
  description = "A list of availability zones specified as argument to this module"
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}

# DB
variable "port_db" {
  description = "Port database. Ex: MySql(3306), PostgreSQL(5432)"
  type        = string
}

# ALB
variable "alb_health_check_path" {
  description = "Health check path"
  type        = string
}

variable "alb_enable_stickiness" {
  description = "Enable stickiness (True or False)"
  type        = bool
}
variable "alb_stickiness_duration" {
  description = "Duration stickiness (seconds)"
  type        = number
}
