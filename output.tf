output "lb_dns_name" {
  description = "Loadbalancer DNS Name"
  value       = "${aws_lb.wordpress.dns_name}"
}

output "cf_dns_name" {
  description = "Cloudfront DNS Name"
  value       = "${aws_cloudfront_distribution.wordpress.domain_name}"
}

output "wordpress_url" {
  description = "Wordpress Site URL"
  value       = "https://${aws_cloudfront_distribution.wordpress.domain_name}"
}

output "wordpress_user" {
  description = "Wordpress username"
  value       = "${random_string.wordpress_admin_user.result}"
  sensitive   = true
}

output "wordpress_password" {
  description = "Wordpress password"
  value       = "${random_string.wordpress_admin_password.result}"
  sensitive   = true
}
