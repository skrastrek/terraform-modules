locals {
  config = {
    type = "metric"

    width  = var.width
    height = var.height

    x = var.position_x
    y = var.position_y

    properties = {
      title    = var.title
      region   = "us-east-1"
      period   = var.period
      view     = "timeSeries"
      stacked  = false
      liveData = var.display_live_data

      yAxis = {
        left = {
          label     = "Bytes"
          showUnits = false
        }
      }

      metrics = [
        [
          "AWS/CloudFront",
          "BytesDownloaded",
          "Region",
          "Global",
          "DistributionId",
          var.cloudfront_distribution_id,
          {
            stat  = "Sum"
            label = "Downloaded"
            color = var.label_color_bytes_downloaded
          }
        ],
        [
          "AWS/CloudFront",
          "BytesUploaded",
          "Region",
          "Global",
          "DistributionId",
          var.cloudfront_distribution_id,
          {
            stat  = "Sum"
            label = "Uploaded"
            color = var.label_color_bytes_uploaded
          }
        ],
      ]
    }
  }
}
