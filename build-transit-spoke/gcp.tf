# us-west1 

module "gcptgw16" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "1.1.0"
  cloud   = "GCP"
  name    = "gcptgw16"
  region  = "us-west1"
  cidr    = "10.16.0.0/16"
  account = var.gcp_account_name
}

module "prod7" {
  source     = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version    = "1.1.0"
  cloud      = "GCP"
  name       = "prod7"
  region     = "us-west1"
  cidr       = "10.7.0.0/16"
  account    = var.gcp_account_name
  transit_gw = module.gcptgw16.transit_gateway.gw_name
}

module "dev6" {
  source     = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version    = "1.1.0"
  cloud      = "GCP"
  name       = "dev6"
  region     = "us-west1"
  cidr       = "10.6.0.0/16"
  account    = var.gcp_account_name
  transit_gw = module.gcptgw16.transit_gateway.gw_name
}

# us-east1

module "gcptgw17" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "1.1.0"
  cloud   = "GCP"
  name    = "gcptgw17"
  region  = "us-east1"
  cidr    = "10.17.0.0/16"
  account = var.gcp_account_name
}

module "prod9" {
  source     = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version    = "1.1.0"
  cloud      = "GCP"
  name       = "prod9"
  region     = "us-east1"
  cidr       = "10.9.0.0/16"
  account    = var.gcp_account_name
  transit_gw = module.gcptgw17.transit_gateway.gw_name
}

module "dev8" {
  source     = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version    = "1.1.0"
  cloud      = "GCP"
  name       = "dev8"
  region     = "us-east1"
  cidr       = "10.8.0.0/16"
  account    = var.gcp_account_name
  transit_gw = module.gcptgw17.transit_gateway.gw_name
}