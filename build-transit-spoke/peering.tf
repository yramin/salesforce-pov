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