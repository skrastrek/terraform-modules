resource "aws_cloudfront_function" "this" {
  name    = "options-success"
  runtime = "cloudfront-js-2.0"
  comment = "Allows any OPTIONS request to succeed."
  publish = true
  code    = file("${path.module}/resources/index.js")
}
