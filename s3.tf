resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "frontend" {
  bucket = "movie-app-frontend-${random_id.bucket_id.hex}"

  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "frontend_config" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Upload modified frontend to S3
resource "null_resource" "upload_frontend_to_s3" {
  depends_on = [null_resource.prepare_frontend]

  provisioner "local-exec" {
    command = <<EOT
      aws s3 cp frontend/index_final.html s3://${aws_s3_bucket.frontend.bucket}/index.html --acl public-read
    EOT
  }
}
resource "aws_s3_bucket_public_access_block" "frontend_block" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })
}
