
# Create a new Web droplet in the nyc2 region
resource "digitalocean_droplet" "web" {
    image = "ubuntu-14-04-x64"
    name = "web-1"
    region = "nyc3"
    size = "512mb"
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

    connection {
      user = "root"
      type = "ssh"
      key_file = "${var.pvt_key}"
      timeout = "2m"
    }

    provisioner "remote-exec" {
      inline = [
        "export PATH=$PATH:/usr/bin",
        # install nginx
        "sudo apt-get update",
        "sudo apt-get -y install nginx"
      ]
    }
}

output "ipv4" {
    value = "${digitalocean_droplet.web.ipv4_address}"
}
