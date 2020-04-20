terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "kubernetes_namespace" "create_namespaces" {
  count = length(var.namespaces)
    metadata {

      name= var.namespaces[count.index]


    }

}

resource "kubernetes_deployment" "deploy_pod" {
  metadata {
    name = var.pod_name
    #namespace = var.namespaces[0]
    labels = {

      label = var.pod_label
    }
  }

  spec {
    replicas = var.pod_replicas

    selector {
      match_labels = {
        label = var.pod_label
      }
    }

    template {
      metadata {
        labels = {
          label = var.pod_label
        }
      }

      spec {
        container {
          image = var.pod_image
          name  = "example"

          resources {
            limits {

              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 7
            period_seconds        = 7
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "servicenginx"
    #namespace = var.namespaces[0]

  }

  spec {
    selector = {
      app = "${kubernetes_deployment.deploy_pod.metadata.0.labels.label}"
    }
    port {
      port = 80


    }
    type = "LoadBalancer"
  }
}

