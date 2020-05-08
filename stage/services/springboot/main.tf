terraform {
  required_version = ">= 0.12, < 0.13"
}



resource "kubernetes_deployment" "deploypod" {
  metadata {
    name = var.pod_name
    #namespace = var.namespaces[0]
    labels = {

      app = var.pod_label
    }
  }

  spec {
    replicas = var.pod_replicas

    selector {
      match_labels = {
        app = var.pod_label
      }
    }

    template {
      metadata {
        labels = {
          app = var.pod_label
        }
      }

      spec {
        container {
          image = var.pod_image
          name  = var.pod_name

          resources {
            limits {

              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }


        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = var.service_name
    #namespace = var.namespaces[0]

  }

  spec {
    selector = {
      app = "${kubernetes_deployment.deploypod.metadata.0.labels.app}"
      #app = "demo"
    }
    port {
      port = var.service_port


    }
    type = "LoadBalancer"
  }
}

