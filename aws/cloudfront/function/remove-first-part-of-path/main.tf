resource "aws_cloudfront_function" "this" {
  name    = "remove-first-part-of-path"
  runtime = "cloudfront-js-2.0"
  comment = "Removes the first part of the request path."
  publish = true
  code    = file("${path.module}/resources/index.js")
}
