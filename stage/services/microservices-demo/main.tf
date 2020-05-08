terraform {
  required_version = ">= 0.12, < 0.13"
}



resource "kubernetes_deployment" "emailservice" {
  metadata {
    name = "emailservice"
    #namespace = var.namespaces[0]
    labels = {

      app = var.podname[0]
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.podname[0]
      }
    }

    template {
      metadata {
        labels = {
          app = var.podname[0]
        }
      }

      spec {
        termination_grace_period_seconds = 5
        container {
          image = "gcr.io/google-samples/microservices-demo/emailservice:v0.2.0"
          name  = "server"

          port {
            container_port = 8080
          }
          env {
            name = "PORT"
            value = "8080"
          }
          env {
            name = "DISABLE_PROFILER"
            value = "1"
          }
          liveness_probe {
            period_seconds =  5
            exec {
              command = ["/bin/grpc_health_probe", "-addr=:8080"]
            }

          }

          readiness_probe {
            period_seconds =  5
            exec {
              command = ["/bin/grpc_health_probe", "-addr=:8080"]
            }

          }

          resources {
            limits {
              cpu = "100m"
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




resource "kubernetes_service" "emailservice" {
  metadata {
    name = "emailservice"
    #namespace = var.namespaces[0]

  }

  spec {
    selector = {
      app = "${kubernetes_deployment.emailservice.metadata.0.labels.app}"
      #app = "demo"
    }
    port {
      port = 5000
      target_port = 8080


    }
    type = "ClusterIP"
  }
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

resource "kubernetes_deployment" "loadgenerator" {
  metadata {
    name = "loadgenerator"
    #namespace = var.namespaces[0]
    labels = {

      app = var.podname[7]
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.podname[7]
      }
    }

    template {
      metadata {
        labels = {
          app = var.podname[7]
        }

      }

      spec {
        termination_grace_period_seconds = 15

        restart_policy = "Always"
        container {
          image = "gcr.io/google-samples/microservices-demo/loadgenerator:v0.2.0"
          name  = "main"


          env {
            name = "FRONTEND_ADDR"
            value = "frontend:80"
          }
          env {
            name = "USERS"
            value = "10"
          }


          resources {
            limits {
              cpu = "500m"
              memory = "512Mi"
            }
            requests {
              cpu    = "300m"
              memory = "256Mi"
            }
          }



      }
    }
  }
}
}



resource "kubernetes_deployment" "currencyservice" {
  metadata {
    name = "currencyservice"
    #namespace = var.namespaces[0]
    labels = {

      app = var.podname[8]
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.podname[8]
      }
    }

    template {
      metadata {
        labels = {
          app = var.podname[8]
        }

      }

      spec {
        termination_grace_period_seconds = 15

        restart_policy = "Always"
        container {
          image = "gcr.io/google-samples/microservices-demo/currencyservice:v0.2.0"
          name  = "server"
          port {
            name = "grpc"
            container_port = 7000
          }

          env {
            name = "PORT"
            value = "7000"
          }
          readiness_probe {
            exec {command = ["/bin/grpc_health_probe", "-addr=:7000"]}
          }
          liveness_probe {
            exec {command = ["/bin/grpc_health_probe", "-addr=:7000"]}
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

resource "kubernetes_service" "currencyservice" {
  metadata {
    name = "currencyservice"
    #namespace = var.namespaces[0]

  }

  spec {
    selector = {
      app = "${kubernetes_deployment.currencyservice.metadata.0.labels.app}"

    }
    port {
      name = "grpc"
      port = 7000
      target_port = 7000

    }
    type = "ClusterIP"
  }
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

resource "kubernetes_deployment" "adservice" {
  metadata {
    name = "adservice"
    #namespace = var.namespaces[0]
    labels = {

      app = var.podname[11]
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.podname[11]
      }
    }

    template {
      metadata {
        labels = {
          app = var.podname[11]
        }

      }

      spec {
        termination_grace_period_seconds = 15


        container {
          image = "gcr.io/google-samples/microservices-demo/adservice:v0.2.0"
          name  = "server"
          port {
            container_port = 9555
          }

          env {
            name = "PORT"
            value = "9555"
          }
          readiness_probe {
            initial_delay_seconds = 20
            period_seconds = 15
            exec {command = ["/bin/grpc_health_probe", "-addr=:9555"]}
          }
          liveness_probe {
            initial_delay_seconds = 20
            period_seconds = 15
            exec {command = ["/bin/grpc_health_probe", "-addr=:9555"]}
          }



          resources {
            limits {
              cpu = "300m"
              memory = "300Mi"
            }
            requests {
              cpu    = "200m"
              memory = "180Mi"
            }
          }



      }
    }
  }
}
}


resource "kubernetes_service" "adservice" {
  metadata {
    name = "adservice"
    #namespace = var.namespaces[0]

  }

  spec {
    selector = {
      app = "${kubernetes_deployment.adservice.metadata.0.labels.app}"

    }
    port {
      name = "grpc"
      port = 9555
      target_port = 9555

    }
    type = "ClusterIP"
  }
}