output "arn" {
  value = aws_lb.alb.arn
}

output "http_listener_arn" {
  value = aws_alb_listener.http.arn
}

output "https_listener_arn" {
  value = aws_alb_listener.https.arn
}