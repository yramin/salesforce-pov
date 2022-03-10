# us-west-2

module "awstgw13" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "1.1.0"
  cloud   = "AWS"
  name    = "awstgw13"
  region  = "us-west-2"
  cidr    = "10.13.0.0/16"
  account = var.aws_account_name
}

module "prod1" {
  source     = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version    = "1.1.0"
  cloud      = "AWS"
  name       = "prod1"
  region     = "us-west-2"
  cidr       = "10.1.0.0/16"
  account    = aviatrix_account.aws_spoke.account_name
  transit_gw = module.awstgw13.transit_gateway.gw_name
}

resource "aviatrix_gateway" "egress" {
  cloud_type   = 1
  account_name = aviatrix_account.aws_spoke.account_name
  gw_name      = "egress"
  vpc_id       = module.prod1.vpc.vpc_id
  vpc_reg      = "us-west-2"
  gw_size      = "t2.micro"
  subnet       = module.prod1.vpc.public_subnets[0].cidr
}

module "dev2" {
  source     = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version    = "1.1.0"
  cloud      = "AWS"
  name       = "dev2"
  region     = "us-west-2"
  cidr       = "10.2.0.0/16"
  account    = aviatrix_account.aws_spoke.account_name
  transit_gw = module.awstgw13.transit_gateway.gw_name
}

# us-east-1

module "awstgw14" {
  source                  = "terraform-aviatrix-modules/aws-transit-firenet/aviatrix"
  version                 = "5.0.0"
  name                    = "awstgw14"
  region                  = "us-east-1"
  account                 = var.aws_account_name
  cidr                    = "10.14.0.0/16"
  firewall_image          = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"
  prefix                  = false
  suffix                  = false
  bootstrap_bucket_name_1 = aws_s3_bucket.pan_bootstrap_s3.bucket
  iam_role_1              = var.ec2_role_name
}

module "prod3" {
  source     = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version    = "1.1.0"
  cloud      = "AWS"
  name       = "prod3"
  region     = "us-east-1"
  cidr       = "10.3.0.0/16"
  account    = aviatrix_account.aws_spoke.account_name
  transit_gw = module.awstgw14.transit_gateway.gw_name
}

module "dev4" {
  source     = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version    = "1.1.0"
  cloud      = "AWS"
  name       = "dev4"
  region     = "us-east-1"
  cidr       = "10.4.0.0/16"
  account    = aviatrix_account.aws_spoke.account_name
  transit_gw = module.awstgw14.transit_gateway.gw_name
}

module "awstgw15" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "1.1.0"
  cloud   = "AWS"
  name    = "awstgw15"
  region  = "us-east-1"
  cidr    = "10.15.0.0/16"
  account = var.aws_account_name
}

module "tableau5" {
  source     = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version    = "1.1.0"
  cloud      = "AWS"
  name       = "tableau5"
  region     = "us-east-1"
  cidr       = "10.5.0.0/16"
  account    = aviatrix_account.aws_spoke.account_name
  transit_gw = module.awstgw15.transit_gateway.gw_name
}