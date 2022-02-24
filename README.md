# Salesforce POV Terraform

## Prerequisites

* AWS Terraform Provider authentication should be configured. See https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication

## Order To Deploy

1. build-controller-copilot
2. configure-controller
3. build-transit-spoke

## 1. build-controller-copilot

- Update values in `build-controller-copilot/terraform.tfvars`.

- If IAM roles already exist in the AWS account comment out the following lines in `build-controller-copilot/controller.tf`. If the IAM roles do not exist you can leave these lines uncommented.
  ```
  module "aviatrix-iam-roles" {
    source = "github.com/AviatrixSystems/terraform-modules.git//aviatrix-controller-iam-roles?ref=terraform_0.14"
  }
  ```

## 2. configure-controller

- Update values in `configure-controller/terraform.tfvars`.
- For information on how to create the .json file for GCP, see https://docs.aviatrix.com/HowTos/CreateGCloudAccount.html.

## 3. build-transit-spoke

- Update values in `build-transit-spoke/terraform.tfvars`.

## terraform destroy

- `terraform destroy` should be run in the reverse order that `terraform apply` was run:

  1. build-transit-spoke
  2. configure-controller
  3. build-controller-copilot

- In build-controller-copilot, the created VPC will fail to delete. The Aviatrix Controller applies security groups to the VPC which Terraform is not aware of. The workaround is to delete the VPC from the AWS Console and then rerun `terraform destroy`.

  ```
  │ Error: error deleting EC2 VPC (vpc-0d119642abc1484fa): DependencyViolation: The vpc 'vpc-0d119642abc1484fa' has dependencies and cannot be deleted.
  │ 	status code: 400, request id: 952e8a97-2f8d-4ffa-833c-f34a47c01184
  ```
