terraform {
  required_version = ">= 0.12, < 0.13"
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