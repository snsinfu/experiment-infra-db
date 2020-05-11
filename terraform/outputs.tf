output "inventory" {
  value     = data.template_file.inventory.rendered
  sensitive = true
}

data "template_file" "inventory" {
  template = file("${path.module}/assets/inventory.in")
  vars = {
    data_public_address = hcloud_server.data.ipv4_address
  }
}
