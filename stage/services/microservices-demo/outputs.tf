output "external_front" {
  value = "${kubernetes_service.frontend-external.load_balancer_ingress.0.hostname}"

}

