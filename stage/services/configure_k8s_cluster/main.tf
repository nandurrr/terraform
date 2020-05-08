
terraform {
  required_version = ">= 0.12, < 0.13"
}


resource "kubernetes_namespace" "create_namespaces" {
  count = length(var.namespaces)
    metadata {

      name= var.namespaces[count.index]


    }

}
