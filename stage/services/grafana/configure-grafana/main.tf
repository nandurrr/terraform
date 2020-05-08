provider "grafana" {
  url  = "http://192.168.99.100:32439"
  auth = "admin:temporal"
}


resource "grafana_dashboard" "metrics_example" {
  config_json = "${file("grafana-dashboard.json")}"
}


resource "grafana_organization" "org" {
    name         = "Plexus Organization"
    admin_user   = "admin"
    create_users = true
    admins       = [
        "admin@example.com"
    ]
    editors      = [
        "prueba1@example.com",
        "prueba2@example.com"
    ]
    viewers      = [
        "viewer-01@example.com",
        "viewer-02@example.com"
    ]
}