resource "digitalocean_ssh_key" "default" {
  name       = "Terraform SSH Key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}
