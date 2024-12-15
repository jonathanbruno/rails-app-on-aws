resource "aws_s3_bucket" "assets_bucket" {
  bucket = "jb-terraform-assets"

  tags = {
    Name        = "A static site bucket"
    Environment = "Dev"
  }

  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "assets_bucket_ownership_controls" {
  bucket = aws_s3_bucket.assets_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "assets_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.assets_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.assets_pa_block,
  ]

  bucket = aws_s3_bucket.assets_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "assets_pa_block" {
  bucket = aws_s3_bucket.assets_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "add_object_policy" {
  bucket = aws_s3_bucket.assets_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Resource = "${aws_s3_bucket.assets_bucket.arn}/*"
        Principal = "*"
      }
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "assets_bucket_cors" {
  bucket = aws_s3_bucket.assets_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]           # Replace "*" with your CloudFront domain for better security
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket" "images_bucket" {
  bucket = "jb-terraform-images"

  tags = {
    Name        = "Images bucket"
    Environment = "Dev"
  }

  force_destroy = true
}
