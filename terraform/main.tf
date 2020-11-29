terraform {
  backend "remote" {
    organization = "ajfriesen"

    workspaces {
      name = "testing"
    }
  }
}

variable "hcloud_token" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "docker_host" {
  name        = "testing"
  image       = "ubuntu-20.04"
  server_type = "cx11"
  user_data   = file("cloud-init")
}

resource "hcloud_volume" "data_volume" {
  name = "data"
  size = 10
}

resource "hcloud_volume_attachment" "data_volume_attachment" {
  volume_id = hcloud_volume.data_volume.id
  server_id = hcloud_server.docker_host.id
  automount = true
}

output "server_ip" {
  value = hcloud_server.docker_host.ipv4_address
}