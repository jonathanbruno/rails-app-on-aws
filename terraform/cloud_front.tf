resource "aws_cloudfront_distribution" "jb-cloudlfront-distribution" {
  origin {
    domain_name              = aws_s3_bucket.static_site_bucket.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.static_site_bucket.id
  }

  enabled             = true
  comment             = "Cloudfront distribution for static site"
  default_root_object = "index.html"
  aliases             = [var.blog_domain]

  tags = {
    Environment = "production"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method = "sni-only"

  }

   default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.static_site_bucket.id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
}