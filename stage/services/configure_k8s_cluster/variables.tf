variable "namespaces" {
  description = "Definimos los diferentes namespaces que tendrá nuestro cluster "
  type = list(string)
  default= ["stage","prod"]

}

