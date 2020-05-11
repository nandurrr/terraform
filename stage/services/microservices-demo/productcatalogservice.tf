terraform {
  required_version = ">= 0.12, < 0.13"
}


resource "kubernetes_deployment" "productcatalogservice" {
  metadata {
    name = "productcatalogservice"
    #namespace = var.namespaces[0]
    labels = {

      app = var.podname[5]
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.podname[5]
      }
    }

    template {
      metadata {
        labels = {
          app = var.podname[5]
        }

      }

      spec {
        termination_grace_period_seconds = 5
        container {
          image = "gcr.io/google-samples/microservices-demo/productcatalogservice:v0.2.0"
          name  = "server"

          port {
            container_port = 3550
          }
          env {
            name = "PORT"
            value = "3550"
          }

          liveness_probe {

            exec {
              command = ["/bin/grpc_health_probe", "-addr=:3550"]
            }

          }



          readiness_probe {

            exec {
              command = ["/bin/grpc_health_probe", "-addr=:3550"]
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

resource "kubernetes_service" "productcatalogservice" {
  metadata {
    name = "productcatalogservice"
    #namespace = var.namespaces[0]

  }

  spec {
    selector = {
      app = "${kubernetes_deployment.productcatalogservice.metadata.0.labels.app}"

    }
    port {
      name = "grpc"
      port = 3550
      target_port = 3550

    }
    type = "ClusterIP"
  }
}
