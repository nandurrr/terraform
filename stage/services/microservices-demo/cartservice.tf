terraform {
  required_version = ">= 0.12, < 0.13"
}


resource "kubernetes_deployment" "cartservice" {
  metadata {
    name = "cartservice"
    #namespace = var.namespaces[0]
    labels = {

      app = var.podname[6]
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.podname[6]
      }
    }

    template {
      metadata {
        labels = {
          app = var.podname[6]
        }

      }

      spec {
        termination_grace_period_seconds = 15
        container {
          image = "gcr.io/google-samples/microservices-demo/cartservice:v0.2.0"
          name  = "server"

          port {
            container_port = 7070
          }
          env {
            name = "REDIS_ADDR"
            value = "redis-cart:6379"
          }
          env {
            name = "PORT"
            value = "7070"
          }
          env {
            name = "LISTEN_ADDR"
            value = "0.0.0.0"
          }

          liveness_probe {
            initial_delay_seconds = 15
            period_seconds = 10
            exec {
              command = ["/bin/grpc_health_probe", "-addr=:7070", "-rpc-timeout=5s"]
            }

          }



          readiness_probe {
            initial_delay_seconds = 15
            exec {
              command = ["/bin/grpc_health_probe", "-addr=:7070", "-rpc-timeout=5s"]
            }

          }

          resources {
            limits {
              cpu = "300m"
              memory = "128Mi"
            }
            requests {
              cpu    = "200m"
              memory = "64Mi"
            }
          }



      }
    }
  }
}
}

resource "kubernetes_service" "cartservice" {
  metadata {
    name = "cartservice"
    #namespace = var.namespaces[0]

  }

  spec {
    selector = {
      app = "${kubernetes_deployment.cartservice.metadata.0.labels.app}"

    }
    port {
      name = "grpc"
      port = 7070
      target_port = 7070

    }
    type = "ClusterIP"
  }
}