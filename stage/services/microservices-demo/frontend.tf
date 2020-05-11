terraform {
  required_version = ">= 0.12, < 0.13"
}


resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "frontend"
    #namespace = var.namespaces[0]
    labels = {

      app = var.podname[3]
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.podname[3]
      }
    }

    template {
      metadata {
        labels = {
          app = var.podname[3]
        }

      }

      spec {
        termination_grace_period_seconds = 5
        container {
          image = "gcr.io/google-samples/microservices-demo/frontend:v0.2.0"
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
          env {
            name = "CURRENCY_SERVICE_ADDR"
            value = "currencyservice:7000"
          }
          env {
            name = "CART_SERVICE_ADDR"
            value = "cartservice:7070"
          }

          env {
            name = "RECOMMENDATION_SERVICE_ADDR"
            value = "recommendationservice:8080"
          }
          env {
            name = "SHIPPING_SERVICE_ADDR"
            value = "shippingservice:50051"
          }
          env {
            name = "CHECKOUT_SERVICE_ADDR"
            value = "checkoutservice:5050"
          }
          env {
            name = "AD_SERVICE_ADDR"
            value = "adservice:9555"
          }
          env {
            name = "ENV_PLATFORM"
            value = "gcp"
          }
          liveness_probe {
            initial_delay_seconds = 10

            http_get {
              path = "/_healthz"
              port = 8080
              http_header {
                name = "Cookie"
                value = "shop_session-id=x-liveness-probe"
              }
            }

          }

          readiness_probe {
            initial_delay_seconds = 10
            http_get {
              path = "/_healthz"
              port = 8080
              http_header {
                name = "Cookie"
                value = "shop_session-id=x-readiness-probe"
              }
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


resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend"
    #namespace = var.namespaces[0]

  }

  spec {
    selector = {
      app = "${kubernetes_deployment.frontend.metadata.0.labels.app}"

    }
    port {
      name = "http"
      port = 80
      target_port = 8080

    }
    type = "ClusterIP"
  }
}



resource "kubernetes_service" "frontend-external" {
  metadata {
    name = "frontend-external"
    #namespace = var.namespaces[0]

  }

  spec {
    selector = {
      app = "${kubernetes_deployment.frontend.metadata.0.labels.app}"

    }
    port {
      name = "http"
      port = 80
      target_port = 8080

    }
    type = "LoadBalancer"
  }
}