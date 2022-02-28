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