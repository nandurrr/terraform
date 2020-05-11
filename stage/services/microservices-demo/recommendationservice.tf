terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "kubernetes_deployment" "recommendationservice" {
  metadata {
    name = "recommendationservice"
    #namespace = var.namespaces[0]
    labels = {

      app = var.podname[2]
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.podname[2]
      }
    }

    template {
      metadata {
        labels = {
          app = var.podname[2]
        }
      }

      spec {
        termination_grace_period_seconds = 15
        container {
          image = "gcr.io/google-samples/microservices-demo/recommendationservice:v0.2.0"
          name  = "server"

          port {
            container_port = 8080
          }
          env {
            name = "PORT"
            value = "8080"
          }
          env {
            name = "PRODUCT_CATALOG_SERVICE_ADDR"
            value = "productcatalogservice:3550"
          }

          liveness_probe {
            period_seconds = 10
            exec {
              command = ["/bin/grpc_health_probe", "-addr=:8080"]
            }

          }

          readiness_probe {
            period_seconds = 10
            exec {
              command = ["/bin/grpc_health_probe", "-addr=:8080"]
            }

          }

          resources {
            limits {
              cpu = "200m"
              memory = "450Mi"
            }
            requests {
              cpu    = "100m"
              memory = "220Mi"
            }
          }



      }
    }
  }
}
}

resource "kubernetes_service" "recommendationservice" {
  metadata {
    name = "recommendationservice"
    #namespace = var.namespaces[0]

  }

  spec {
    selector = {
      app = "${kubernetes_deployment.recommendationservice.metadata.0.labels.app}"
      #app = "demo"
    }
    port {
      name = "grpc"
      port = 8080
      target_port = 8080

    }
    type = "ClusterIP"
  }
}
