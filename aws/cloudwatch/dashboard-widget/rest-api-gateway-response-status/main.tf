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
      stacked   = true
      liveData  = var.display_live_data

      yAxis     = {
        left = {
          label     = "Count",
          showUnits = false
        }
      }

      metrics   = [
        [
          "AWS/ApiGateway",
          "5xx",
          "Stage",
          var.api_gateway_stage,
          "ApiName",
          var.api_gateway_name,
          {
            id    = "server_errors"
            stat  = "Sum"
            label = "5xx"
            color = var.label_color_5xx
          }
        ],
        [
          "AWS/ApiGateway",
          "4xx",
          "Stage",
          var.api_gateway_stage,
          "ApiName",
          var.api_gateway_name,
          {
            id    = "client_errors"
            stat  = "Sum"
            label = "4xx"
            color = var.label_color_4xx
          }
        ],
        [
          {
            label       = "2xx"
            color       = var.label_color_2xx
            expression  = "requests - (server_errors + client_errors)"
          }
        ],
        [
          "AWS/ApiGateway",
          "Count",
          "Stage",
          var.api_gateway_stage,
          "ApiName",
          var.api_gateway_name,
          {
            id    = "requests"
            stat  = "Sum"
            label = "Request"
            color = var.label_color_request
          }
        ]
      ]
    }
  }
}