terraform {
  required_version = ">= 0.12, < 0.13"
}


resource "kubernetes_deployment" "deploydbpod" {
  metadata {
    name = var.poddb_name
    #namespace = var.namespaces[0]
    labels = {

      app = var.poddb_label
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.poddb_label
      }
    }

    template {
      metadata {
        labels = {
          app = var.poddb_label
        }
      }

      spec {
        container {
          image = var.poddb_image
          name  = var.poddb_name

          env {
            name = "MYSQL_DATABASE"
            value = "sm2demodb"
          }
          env {
            name = "MYSQL_USER"
            value = "userdb"
          }
          env {
            name = "MYSQL_PASSWORD"
            value = "temporal"
          }
          env {
            name= "MYSQL_ROOT_PASSWORD"
            value= "temporal"
          }

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

resource "kubernetes_service" "servicejdbc" {
  metadata {
    name = var.servicedb_name


  }

  spec {
    selector = {
      app = "${kubernetes_deployment.deploydbpod.metadata.0.labels.app}"

    }
    port {
      port = var.servicedb_port


    }
    type = "ClusterIP"
    cluster_ip = "172.20.55.122"
  }
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

          env {
            name = "SPRING_DATASOURCE_URL"
            value = "jdbc:mysql://172.20.55.122:3306/sm2demodb?autoReconnect=true&useSSL=false"
          }
          env {
            name = "SPRING_DATASOURCE_USERNAME"
            value = "userdb"
          }
          env {
            name = "SPRING_DATASOURCE_PASSWORD"
            value = "temporal"
          }
          env {
            name = "SPRING_JPA_GENERATE_DDL"
            value = "TRUE"
          }

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

