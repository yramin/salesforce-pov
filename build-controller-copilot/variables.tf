variable "admin_email" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "access_account_name" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "incoming_ssl_cidr" {
  type = list(any)
}

variable "ec2_role_name" {
  type = string
}

variable "app_role_name" {
  type = string
}