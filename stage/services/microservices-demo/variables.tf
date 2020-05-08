
variable "podname" {
    description = "Definimos los diferentes labels del pod"
    type = list(string)
    default= ["emailservice","checkoutservice","recommendationservice","frontend","paymentservice","productcatalogservice","cartservice","loadgenerator","currencyservice","shippingservice","redis-cart","adservice"]
}