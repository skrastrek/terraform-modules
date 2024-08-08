data "aws_region" "current" {}

locals {
  config = {
    type        = "metric"

    width       = var.width
    height      = var.height

    x           = var.position_x
    y           = var.position_y

    properties  = {
      title     = var.title
      region    = data.aws_region.current.id
      period    = var.period
      view      = "timeSeries"
      stacked   = false
      liveData  = var.display_live_data

      metrics = [
        [
          "AWS/ApiGateway",
          "Latency",
          "Stage",
          var.api_gateway_stage,
          "ApiName",
          var.api_gateway_name,
          {
            stat  = "p10"
            label = "p10"
            color = var.label_color_p10
          }
        ],
        [
          "AWS/ApiGateway",
          "Latency",
          "Stage",
          var.api_gateway_stage,
          "ApiName",
          var.api_gateway_name,
          {
            stat  = "p50"
            label = "p50"
            color = var.label_color_p50
          }
        ],
        [
          "AWS/ApiGateway",
          "Latency",
          "Stage",
          var.api_gateway_stage,
          "ApiName",
          var.api_gateway_name,
          {
            stat  = "p90"
            label = "p90"
            color = var.label_color_p90
          }
        ]
      ]
    }
  }
}