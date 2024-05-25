resource "aws_s3_bucket" "my_bucket" {
  bucket = "newdemobuckettest123" 
}

resource "aws_s3_object" "indexFile" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "index.html"
  source = "./index.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "image" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "aws.png"
  source = "./aws.png"
  acl    = "public-read"
  content_type = "image/png"
}
resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership_controls,
    aws_s3_bucket_public_access_block.public_access,
  ]

  bucket = aws_s3_bucket.my_bucket.id
  acl    = "public-read"
}