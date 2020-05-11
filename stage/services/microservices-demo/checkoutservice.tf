
terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "kubernetes_deployment" "checkoutservice" {
  metadata {
    name = "checkoutservice"
    #namespace = var.namespaces[0]
    labels = {

      app = var.podname[1]
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.podname[1]
      }
    }

    template {
      metadata {
        labels = {
          app = var.podname[1]
        }
      }

      spec {
        termination_grace_period_seconds = 5
        container {
          image = "gcr.io/google-samples/microservices-demo/checkoutservice:v0.2.0"
          name  = "server"

          port {
            container_port = 5050
          }
          env {
            name = "PORT"
            value = "5050"
          }
          env {
            name = "PRODUCT_CATALOG_SERVICE_ADDR"
            value = "productcatalogservice:3550"
          }
          env {
            name = "SHIPPING_SERVICE_ADDR"
            value = "shippingservice:50051"
          }
          env {
            name = "PAYMENT_SERVICE_ADDR"
            value = "paymentservice:50051"
          }

          env {
            name = "EMAIL_SERVICE_ADDR"
            value = "emailservice:5000"
          }
          env {
            name = "CURRENCY_SERVICE_ADDR"
            value = "currencyservice:7000"
          }
          env {
            name = "CART_SERVICE_ADDR"
            value = "cartservice:7070"
          }
          liveness_probe {

            exec {
              command = ["/bin/grpc_health_probe", "-addr=:5050"]
            }

          }

          readiness_probe {

            exec {
              command = ["/bin/grpc_health_probe", "-addr=:5050"]
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

resource "kubernetes_service" "checkoutservice" {
  metadata {
    name = "checkoutservice"
    #namespace = var.namespaces[0]

  }

  spec {
    selector = {
      app = "${kubernetes_deployment.checkoutservice.metadata.0.labels.app}"
      #app = "demo"
    }
    port {
      name = "grpc"
      port = 5050
      target_port = 5050


    }
    type = "ClusterIP"
  }
}
