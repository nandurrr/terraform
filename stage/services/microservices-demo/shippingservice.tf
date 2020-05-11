terraform {
  required_version = ">= 0.12, < 0.13"
}


resource "kubernetes_deployment" "shippingservice" {
  metadata {
    name = "shippingservice"
    #namespace = var.namespaces[0]
    labels = {

      app = var.podname[9]
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.podname[9]
      }
    }

    template {
      metadata {
        labels = {
          app = var.podname[9]
        }

      }

      spec {
        termination_grace_period_seconds = 15

        restart_policy = "Always"
        container {
          image = "gcr.io/google-samples/microservices-demo/shippingservice:v0.2.0"
          name  = "server"
          port {
            name = "grpc"
            container_port = 50051
          }

          env {
            name = "PORT"
            value = "50051"
          }
          readiness_probe {
            period_seconds = 5
            exec {command = ["/bin/grpc_health_probe", "-addr=:50051"]}
          }
          liveness_probe {
            exec {command = ["/bin/grpc_health_probe", "-addr=:50051"]}
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


resource "kubernetes_service" "shippingservice" {
  metadata {
    name = "shippingservice"
    #namespace = var.namespaces[0]

  }

  spec {
    selector = {
      app = "${kubernetes_deployment.shippingservice.metadata.0.labels.app}"

    }
    port {
      name = "grpc"
      port = 50051
      target_port = 50051

    }
    type = "ClusterIP"
  }
}