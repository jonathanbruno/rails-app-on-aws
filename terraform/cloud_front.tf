resource "aws_cloudfront_distribution" "jb-cloudlfront-distribution" {
  origin {
    domain_name = aws_lb.jb-load-balancer.dns_name
    origin_id   = aws_lb.jb-load-balancer.id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only" # Choose http-only, https-only, or match-viewer
      origin_ssl_protocols   = ["TLSv1.2"]  # Required if using https
    }
  }

  origin {
    domain_name              = aws_s3_bucket.assets_bucket.bucket_regional_domain_name
    #origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = aws_s3_bucket.assets_bucket.id
  }


  enabled             = true
  comment             = "Cloudfront distribution for static site"
  default_root_object = ""
  aliases             = ["app.jonathanbruno.dev"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn = "arn:aws:acm:us-east-1:443370703773:certificate/edccd4fc-b2c1-447e-a026-141245696feb"
    ssl_support_method  = "sni-only"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_lb.jb-load-balancer.id

    #forwarded_values {
    #  query_string = false
    #  cookies {
    #    forward = "all"
    #  }
    #}

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    #default_ttl            = 3600
    #max_ttl                = 86400

    cache_policy_id          = "83da9c7e-98b4-4e11-a168-04f0df8e2c65"
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/assets/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.assets_bucket.id
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "acba4595-bd28-49b8-b9fe-13317c0390fa"
    response_headers_policy_id = "60669652-455b-4ae9-85a4-c4c02393f86c"

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
}