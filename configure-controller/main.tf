terraform {
  required_providers {
    aviatrix = {
      source  = "AviatrixSystems/aviatrix"
      version = "2.21.0-6.6.ga"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.2.0"
    }
  }
}

provider "aviatrix" {
  controller_ip           = var.aviatrix_controller_ip
  username                = var.aviatrix_username
  password                = var.aviatrix_password
  skip_version_validation = "true" # Only needed if running Aviatrix Controller version 6.5
}

provider "aws" {
  region = "us-west-1"
}

resource "aviatrix_account" "gcp" {
  account_name                        = var.gcp_account_name
  cloud_type                          = 4
  gcloud_project_id                   = var.gcloud_project_id
  gcloud_project_credentials_filepath = var.gcloud_project_credentials_filepath
}

resource "aws_s3_bucket" "backups_s3" {
  bucket_prefix = "aviatrix-backups"
  force_destroy = true
  tags = {
    Name = "aviatrix-backups"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.backups_s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aviatrix_controller_config" "backup_config" {
  backup_configuration = true
  backup_cloud_type    = 1
  backup_account_name  = var.access_account_name
  backup_bucket_name   = aws_s3_bucket.backups_s3.id
}