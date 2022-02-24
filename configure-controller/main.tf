terraform {
  required_providers {
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
      version = "2.21.0-6.6.ga"
    }
  }
}

provider "aviatrix" {
  controller_ip           = var.aviatrix_controller_ip
  username                = var.aviatrix_username
  password                = var.aviatrix_password
  skip_version_validation = "true" # Only needed if running Aviatrix Controller version 6.5
}

resource "aviatrix_account" "gcp" {
  account_name                        = var.gcp_account_name
  cloud_type                          = 4
  gcloud_project_id                   = var.gcloud_project_id
  gcloud_project_credentials_filepath = var.gcloud_project_credentials_filepath
}
