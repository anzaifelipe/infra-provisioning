resource "aws_service_discovery_private_dns_namespace" "namespace" {
  count = var.enable_service_discovery ? 1 : 0 
  name        = var.service_namespace_name
  description = var.description_namespace
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "sds" {
  count = var.enable_service_discovery ? 1 : 0

  name = var.service_name

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.namespace[0].id

    dns_records {
      ttl  = var.service_discovery_dns_ttl
      type = var.service_discovery_dns_record_type
    }

    routing_policy = var.service_discovery_routing_policy
  }

  health_check_custom_config {
    failure_threshold = var.service_discovery_failure_threshold
  }
}