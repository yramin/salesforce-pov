# Salesforce POV Terraform

## Prerequisites

- AWS Terraform provider authentication should be configured. See https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication
- Increase VPC and Elastic IP quotas in us-west-1 and us-east-1.
- Subscribe to the following AMIs:
  - Aviatrix Controller: https://aws.amazon.com/marketplace/pp?sku=2ewplxno8kih1clboffpdrp9q
  - Aviatrix CoPilot: https://aws.amazon.com/marketplace/pp?sku=bjl4xsl3kdlaukmyctcb7np9s
  - Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1: https://aws.amazon.com/marketplace/pp?sku=e9yfvyj3uag5uo5j2hjikv74n
  - Cisco Cloud Services Router (CSR) 1000V: https://aws.amazon.com/marketplace/pp?sku=5tiyrfb5tasxk9gmnab39b843

## Order To Deploy

1. build-controller-copilot
2. build-transit-spoke

## 1. build-controller-copilot

- Update values in `build-controller-copilot/terraform.tfvars`.

## 2. build-transit-spoke

- Update values in `build-transit-spoke/terraform.tfvars`.
- For information on how to create the .json file for GCP, see https://docs.aviatrix.com/HowTos/CreateGCloudAccount.html.
- For information on Aviatrix Controller HA, see https://docs.aviatrix.com/HowTos/controller_ha.html.

## terraform destroy

- `terraform destroy` should be run in the reverse order that `terraform apply` was run:

  1. build-transit-spoke
  2. build-controller-copilot

- In build-controller-copilot, the created VPC will fail to delete. The Aviatrix Controller applies security groups to the VPC which Terraform is not aware of. The workaround is to delete the VPC from the AWS Console and then rerun `terraform destroy`.

  ```
  │ Error: error deleting EC2 VPC (vpc-0d119642abc1484fa): DependencyViolation: The vpc 'vpc-0d119642abc1484fa' has dependencies and cannot be deleted.
  │ 	status code: 400, request id: 952e8a97-2f8d-4ffa-833c-f34a47c01184
  ```

## PAN Bootstrap

- The sample bootstrap.xml file configuration is based on the configuration in https://docs.aviatrix.com/HowTos/config_paloaltoVM.html
- The following accounts are created:
  - Username: admin Password: Aviatrix12345#
  - Username: admin-api Password: Aviatrix12345#
  - These usernames/passwords are hardcoded in bootstrap.xml and are not based on any of the passwords in `terraform.tfvars`.
  - Vendor integration assumes that the admin-api user and password is as listed. If you create a new bootstrap.xml, either create the same admin-api user and password or update the vendor integration resources in `build-transit-spoke/pan.tf` with the username and password that was created:
    ```
    data "aviatrix_firenet_vendor_integration" "fw1" {
      vpc_id      = module.awstgw14.aviatrix_firewall_instance[0].vpc_id
      instance_id = module.awstgw14.aviatrix_firewall_instance[0].instance_id
      vendor_type = "Palo Alto Networks VM-Series"
      public_ip   = module.awstgw14.aviatrix_firewall_instance[0].public_ip
      username    = "admin-api"
      password    = "Aviatrix12345#"
      save        = true
      depends_on = [
        time_sleep.wait_for_fw_instances
      ]
    }

    data "aviatrix_firenet_vendor_integration" "fw2" {
      vpc_id      = module.awstgw14.aviatrix_firewall_instance[1].vpc_id
      instance_id = module.awstgw14.aviatrix_firewall_instance[1].instance_id
      vendor_type = "Palo Alto Networks VM-Series"
      public_ip   = module.awstgw14.aviatrix_firewall_instance[1].public_ip
      username    = "admin-api"
      password    = "Aviatrix12345#"
      save        = true
      depends_on = [
        time_sleep.wait_for_fw_instances
      ]
    }
    ```
