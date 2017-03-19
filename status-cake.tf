# resource "statuscake_test" "nodes" {
#   count         = "${var.total_count}"
#   website_name  = "Bitcoin Tests ${format("%02d", count.index+1)}"
#   website_url   = "${element(digitalocean_droplet.node.*.ipv4_address, count.index)}"
#   port          = 8333
#   test_type     = "TCP"
#   confirmations = 1
#   check_rate    = 300
#   paused        = false
# }

