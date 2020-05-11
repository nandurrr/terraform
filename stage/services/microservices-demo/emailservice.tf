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