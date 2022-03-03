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
  key    = "bootstrap.xml"
  source = "pan/bootstrap.xml"
}

resource "aws_s3_object" "initcfgtxt" {
  bucket = aws_s3_bucket.pan_bootstrap_s3.id
  key    = "init-cfg.txt"
  source = "pan/init-cfg.txt"
}