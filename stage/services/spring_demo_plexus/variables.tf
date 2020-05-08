
########################## Variables deployment en kubernetes backend#############################
variable "pod_replicas" {
    description = "Definimos los diferentes labels del pod"
    type = number
    default= 1
}

#variables pod db mysql
variable "pod_name" {
  description = "Nombre del pod a desplegar"
  type = string
  default = "springbootapp"

}

variable "pod_image" {
  description = "Nombre de la imagen, por ejemplo 'nginx:latest'"
  type = string
  default = "nandovalin/kubernetes-images:springplexus"

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

############################# variables pod db mysql ############################

variable "poddb_name" {
  description = "Nombre del pod a desplegar"
  type = string
  default = "mysqldb"

}


variable "poddb_image" {
  description = "Nombre de la imagen, por ejemplo 'nginx:latest'"
  type = string
  default = "mysql:5.6"

}
variable "poddb_label" {
    description = "Definimos los diferentes labels del pod"
    type = string
    default= "mysql"
}
variable "servicedb_name" {
    description = "Definimos el nombre del servicio"
    type = string
    default= "springservicedb"
}

variable "servicedb_port" {
  description = "Definimos el puerto en el que vamos a exponer al exterior el servicio "
  type = number
  default = 3306
}