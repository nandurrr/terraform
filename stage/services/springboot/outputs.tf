output "dns_service" {
  value = "${kubernetes_service.frontend.load_balancer_ingress.0.hostname}"

}
output "replicas_num" {
  value = "${kubernetes_deployment.deploypod.spec.0.replicas}"

}