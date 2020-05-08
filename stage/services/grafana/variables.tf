variable "pod_name" {
  description = "Nombre del pod a desplegar"
  type = string
  default = "grafana-server"

}


variable "pod_image" {
  description = "Nombre de la imagen, por ejemplo 'nginx:latest'"
  type = string
  default = "grafana/grafana:latest"

}
variable "pod_label" {
    description = "Definimos los diferentes labels del pod"
    type = string
    default= "grafana"
}
variable "service_name" {
    description = "Definimos el nombre del servicio"
    type = string
    default= "grafanaservice"
}

variable "service_port" {
  description = "Definimos el puerto en el que vamos a exponer al exterior el servicio "
  type = number
  default = 3000
}