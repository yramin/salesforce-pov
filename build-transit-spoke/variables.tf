variable "admin_email" {
  type = string
}

variable "controller_name" {
  type = string
}

variable "aws_account_name" {
  type = string
}

variable "aws_account_name_spoke" {
  type = string
}

variable "aws_account_number_spoke" {
  type = string
}

variable "ec2_role_name" {
  type = string
}

variable "app_role_name" {
  type = string
}

variable "gcp_account_name_transit" {
  type = string
}

variable "gcloud_project_id_transit" {
  type = string
}

variable "gcloud_project_credentials_filepath_transit" {
  type = string
}

variable "gcp_account_name_spoke" {
  type = string
}

variable "gcloud_project_id_spoke" {
  type = string
}

variable "gcloud_project_credentials_filepath_spoke" {
  type = string
}

variable "aviatrix_controller_ip" {
  type = string
}

variable "aviatrix_username" {
  type = string
}

variable "aviatrix_password" {
  type = string
}

variable "aviatrix_copilot_ip" {
  type = string
}

# variable "onprem_csr_username" {
#   type = string
# }

# variable "onprem_csr_password" {
#   type = string
# }