provider "aws" {
  region = "eu-west-1"
}
variable "user_names" {
  description ="users"
  type= list(string)
  default= ["pandi","covi"]

}
variable "enable_users" {
  description = "If set to true, enable auto scaling"
  type        = bool
}
variable "zones" {
  description ="AWS avalibility zones"
  type = map(string)
  default = {
    "a" = "eu-west-1a"
    "b" = "eu-west-1b"


  }
}

resource "aws_instance" "ubuntu" {
  count = var.enable_users ? 1 : 0
  #for_each = var.zones
  ami = "ami-0f2ed58082cb08a4d"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  #availability_zone = each.value
  availability_zone = "eu-west-1a"

  

}

output "public_ips" {
  value = [for r in aws_instance.ubuntu: r.public_ip]
}