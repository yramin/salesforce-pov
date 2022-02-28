provider "aviatrix" {
  controller_ip           = var.aviatrix_controller_ip
  username                = var.aviatrix_username
  password                = var.aviatrix_password
  skip_version_validation = "true" # Only needed if running Aviatrix Controller version 6.5
}

provider "aws" {
  region = "us-west-1"
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
  backup_account_name  = var.aws_account_name
  backup_bucket_name   = aws_s3_bucket.backups_s3.id
}

module "transit-peering" {
  source  = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version = "1.0.5"
  transit_gateways = [
    module.awstgw13.transit_gateway.gw_name,
    module.awstgw14.transit_gateway.gw_name,
    module.awstgw15.transit_gateway.gw_name,
    module.gcptgw16.transit_gateway.gw_name,
    module.gcptgw17.transit_gateway.gw_name
  ]
}