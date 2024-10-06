# - - - - - - - - - - - - - -
#AWS Global Accelerator
# - - - - - - - - - - - - - -

# Global Acceleratorの作成
resource "aws_globalaccelerator_accelerator" "accelerator_http" {
  name            = "my-accelerator"
  enabled         = true
  ip_address_type = "IPV4"

  attributes {
    flow_logs_enabled = false
  }
}

resource "aws_globalaccelerator_listener" "listener_http" {
  accelerator_arn = aws_globalaccelerator_accelerator.accelerator_http.id
  client_affinity = "SOURCE_IP"
  protocol        = "TCP"

  port_range {
    from_port = 80
    to_port   = 80
  }
}

# エンドポイントグループの作成
resource "aws_globalaccelerator_endpoint_group" "endpoint_group_http" {
  listener_arn          = aws_globalaccelerator_listener.listener_http.id
  endpoint_group_region = "ap-northeast-1"
  endpoint_configuration {
    endpoint_id = aws_lb.alb.arn
    weight      = 128
  }
}
