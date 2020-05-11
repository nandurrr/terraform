terraform {
  required_version = ">= 0.12, < 0.13"
}


resource "kubernetes_deployment" "redis-cart" {
  metadata {
    name = "redis-cart"
    #namespace = var.namespaces[0]
    labels = {

      app = var.podname[10]
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
       app = var.podname[10]
      }
    }

    template {
      metadata {
        labels = {
          app = var.podname[10]
        }

      }

      spec {
        termination_grace_period_seconds = 15

        restart_policy = "Always"

        container {
          image = "redis:alpine"
          name  = "redis"
          port {
            container_port = 6379
          }

          env {
            name = "PORT"
            value = "50051"
          }
          readiness_probe {
            period_seconds = 5
            tcp_socket {
              port = "6379"
            }
          }
          liveness_probe {
            period_seconds = 5
            tcp_socket {
              port = "6379"
            }
          }

          volume_mount {
            mount_path = "/data"
            name = "redis-data"
          }



          resources {
            limits {
              cpu = "125m"
              memory = "256Mi"
            }
            requests {
              cpu    = "70m"
              memory = "200Mi"
            }
          }
        }
        volume {
          name = "redis-data"
          empty_dir {}
        }

    }
  }
}
}


resource "kubernetes_service" "redis-cart" {
  metadata {
    name = "redis-cart"
    #namespace = var.namespaces[0]

  }

  spec {
    selector = {
      app = "${kubernetes_deployment.redis-cart.metadata.0.labels.app}"

    }
    port {
      name = "redis"
      port = 6379
      target_port = 6379

    }
    type = "ClusterIP"
  }
}