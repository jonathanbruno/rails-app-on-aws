data "aws_route53_zone" "jb-app-zone" {
  name = "jonathanbruno.dev"
}

resource "aws_route53_record" "app_record" {
  zone_id = "Z073869138SJ1GR8SQUQK"
  name    = "app"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.jb-cloudlfront-distribution.domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}
