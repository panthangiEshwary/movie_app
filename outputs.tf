output "alb_dns" {
  value = aws_lb.app_lb.dns_name
}

output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.movie_db.endpoint
}

output "s3_website_url" {
  value = "http://${aws_s3_bucket.frontend.bucket}.s3-website-${var.region}.amazonaws.com"
}
