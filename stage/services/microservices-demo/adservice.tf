terraform {
  required_version = ">= 0.12, < 0.13"
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