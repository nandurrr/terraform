terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "kubernetes_deployment" "paymentservice" {
  metadata {
    name = "paymentservice"
    #namespace = var.namespaces[0]
    labels = {

      app = var.podname[4]
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.podname[4]
      }
    }

    template {
      metadata {
        labels = {
          app = var.podname[4]
        }

      }

      spec {
        termination_grace_period_seconds = 15
        container {
          image = "gcr.io/google-samples/microservices-demo/paymentservice:v0.2.0"
          name  = "server"

          port {
            container_port = 50051
          }
          env {
            name = "PORT"
            value = "50051"
          }

          liveness_probe {

            exec {
              command = ["/bin/grpc_health_probe", "-addr=:50051"]
            }

          }



          readiness_probe {

            exec {
              command = ["/bin/grpc_health_probe", "-addr=:50051"]
            }

          }

          resources {
            limits {
              cpu = "200m"
              memory = "128Mi"
            }
            requests {
              cpu    = "100m"
              memory = "64Mi"
            }
          }



      }
    }
  }
}
}

resource "kubernetes_service" "paymentservice" {
  metadata {
    name = "paymentservice"
    #namespace = var.namespaces[0]

  }

  spec {
    selector = {
      app = "${kubernetes_deployment.paymentservice.metadata.0.labels.app}"

    }
    port {
      name = "grpc"
      port = 50051
      target_port = 50051

    }
    type = "ClusterIP"
  }
}
