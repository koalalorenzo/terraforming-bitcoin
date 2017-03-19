output "Bitcoin Nodes IPv4" {
  value = ["${digitalocean_droplet.node.*.ipv4_address}"]
}

output "Bitcoin Nodes IPv6" {
  value = ["${digitalocean_droplet.node.*.ipv6_address}"]
}
