output "lb_dns_name" {
  value = "${aws_lb.wordpress.dns_name}"
}

output "cf_dns_name" {
  value = "${aws_cloudfront_distribution.wordpress.domain_name}"
}
