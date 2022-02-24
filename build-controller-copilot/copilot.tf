resource "aws_ebs_volume" "copilot_vol1" {
  availability_zone = module.aviatrix-controller-build.availability_zone
  size              = 8
  tags = {
    Name = "Aviatrix CoPilot Volume 1"
  }
}

module "copilot_build_aws" {
  source  = "github.com/AviatrixSystems/terraform-modules-copilot.git//copilot_build_aws"
  keypair = "copilot_kp"

  allowed_cidrs = {
    "tcp_cidrs" = {
      protocol = "tcp"
      port     = "443"
      cidrs    = ["0.0.0.0/0"]
    }
    "udp_cidrs_1" = {
      protocol = "udp"
      port     = "5000"
      cidrs    = ["0.0.0.0/0"]
    }
    "udp_cidrs_2" = {
      protocol = "udp"
      port     = "31283"
      cidrs    = ["0.0.0.0/0"]
    }
  }

  additional_volumes = {
    "one" = {
      device_name = "/dev/sdb"
      volume_id   = aws_ebs_volume.copilot_vol1.id
    }
  }
}