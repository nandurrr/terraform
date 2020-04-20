variable "namespaces" {
  description = "Definimos los diferentes namespaces que tendrá nuestro cluster "
  type = list(string)
  default= ["dev","prod"]

}

########################## Variables deployment en kubernetes #############################
variable "pod_replicas" {
    description = "Definimos los diferentes labels del pod"
    type = number
    default= 1
}

variable "pod_name" {
  description = "Nombre del pod a desplegar"
  type = string
  default = "nginx"

}
variable "pod_image" {
  description = "Nombre de la imagen, por ejemplo 'nginx:latest'"
  type = string
  default = "nginx:latest"

}

variable "pod_label" {
    description = "Definimos los diferentes labels del pod"
    type = string
    default= "nginxapp"
}

