terraform {
  required_version = ">= 0.12, < 0.13"
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
