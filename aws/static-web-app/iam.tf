resource "aws_iam_policy" "s3_bucket_read" {
  name   = "${local.name_prefix}-s3-bucket-read"
  policy = module.s3_bucket_read.json
}

module "s3_bucket_read" {
  source = "../iam/policy-documents/s3-bucket-read"

  s3_bucket_arn = aws_s3_bucket.this.arn
}

resource "aws_iam_policy" "s3_bucket_write" {
  name   = "${local.name_prefix}-s3-bucket-write"
  policy = module.s3_bucket_write.json
}

module "s3_bucket_write" {
  source = "../iam/policy-documents/s3-bucket-write"

  s3_bucket_arn = aws_s3_bucket.this.arn
}
