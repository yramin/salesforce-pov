resource "aws_s3_bucket" "pan_bootstrap_s3" {
  bucket_prefix = "pan-bootstrap"
  force_destroy = true
  tags = {
    Name = "pan-bootstrap"
  }
}

resource "aws_s3_bucket_public_access_block" "pan_block" {
  bucket                  = aws_s3_bucket.pan_bootstrap_s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "bootstrapxml" {
  bucket = aws_s3_bucket.pan_bootstrap_s3.id
  key    = "config/bootstrap.xml"
  source = "pan/bootstrap.xml"
}

resource "aws_s3_object" "initcfgtxt" {
  bucket = aws_s3_bucket.pan_bootstrap_s3.id
  key    = "config/init-cfg.txt"
  source = "pan/init-cfg.txt"
}

resource "aws_s3_object" "content" {
  bucket = aws_s3_bucket.pan_bootstrap_s3.id
  key    = "content/"
}

resource "aws_s3_object" "license" {
  bucket = aws_s3_bucket.pan_bootstrap_s3.id
  key    = "license/"
}

resource "aws_s3_object" "software" {
  bucket = aws_s3_bucket.pan_bootstrap_s3.id
  key    = "software/"
}

resource "aws_iam_policy" "pan_bootstrap_policy" {
  name = "bootstrap-VM-S3-policy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:ListBucket"
          ],
          "Resource" : [
            "arn:aws:s3:::*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:GetObject"
          ],
          "Resource" : [
            "arn:aws:s3:::*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "pan_bootstrap_role_policy_attachment" {
  role       = "aviatrix-role-ec2"
  policy_arn = aws_iam_policy.pan_bootstrap_policy.arn
}


resource "time_sleep" "wait_for_fw_instances" {
  create_duration = "15m"
  depends_on = [
    module.awstgw14
  ]
}

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