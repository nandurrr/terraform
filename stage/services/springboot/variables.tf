variable "namespaces" {
  description = "Definimos los diferentes namespaces que tendrá nuestro cluster "
  type = list(string)
  default= ["dev"]

}

########################## Variables deployment en kubernetes #############################
variable "pod_replicas" {
    description = "Definimos los diferentes labels del pod"
    type = number
    default= 2
}

variable "pod_name" {
  description = "Nombre del pod a desplegar"
  type = string
  default = "springbootapp"

}
variable "pod_image" {
  description = "Nombre de la imagen, por ejemplo 'nginx:latest'"
  type = string
  default = "nandovalin/kubernetes-images"

}

variable "pod_label" {
    description = "Definimos los diferentes labels del pod"
    type = string
    default= "demo"
}


#############################Variables del service #############################3
variable "service_name" {
    description = "Definimos el nombre del servicio"
    type = string
    default= "springservice"
}
variable "service_port" {
  description = "Definimos el puerto en el que vamos a exponer al exterior el servicio "
  type = number
  default = 8080
}