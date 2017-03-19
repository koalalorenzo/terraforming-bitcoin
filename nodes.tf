################################################################################
# Bitcoin Classic                                                                 #
################################################################################

resource "digitalocean_droplet" "node" {
  depends_on = ["digitalocean_ssh_key.default"]
  count      = "${var.total_count}"
  ssh_keys   = ["${digitalocean_ssh_key.default.id}"]
  image      = "ubuntu-16-04-x64"
  region     = "${element(keys(var.count_map), count.index)}"
  size       = "512mb"
  ipv6       = true
  name       = "${uuid()}"
  tags       = ["bitcoin"]

  lifecycle {
    create_before_destroy = true
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo apt-get upgrade -qq -y",

      # DigitalOcean monitors
      "sudo curl -sSL https://agent.digitalocean.com/install.sh | sudo sh",

      "sleep 5",
      "sudo fallocate -l 512M /swap1.swap",
      "sudo chmod 0600 /swap1.swap",
      "sudo mkswap /swap1.swap",
      "sudo swapon /swap1.swap",
      "sudo echo '/swap1.swap  none  swap  sw  0  0' >> /etc/fstab",
      "sudo apt-get install -qq -y fail2ban ufw mosh apt-transport-https ca-certificates software-properties-common",
      "sudo ufw allow ssh",
      "sudo ufw allow mosh",
      "sudo ufw default deny incoming",
      "sudo ufw default allow outgoing",
      "sudo ufw allow 8333",
      "sudo apt-add-repository ppa:bitcoinclassic/bitcoinclassic",
      "sudo apt-get update",
      "sudo apt-get install -qq -y bitcoind",
      "sudo adduser --disabled-password --gecos '' bitcoin",
      "su bitcoin -c 'mkdir -p ~/.ssh'",
      "sudo cp ~/.ssh/authorized_keys /home/bitcoin/.ssh/authorized_keys",
      "sudo chown bitcoin /home/bitcoin/.ssh/authorized_keys",
      "sudo chmod 0644 /home/bitcoin/.ssh/authorized_keys",

      ## Uncomment the next line to disable Root access from SSH.
      ## No user can use sudo for security reason, so if disabled, the only
      ## way to upgrade is re-create the droplet by marking it as tainted.
      ## If disabled, just connect using 'mosh root@IP'
      # "sudo sed -i 's/\\(PermitRootLogin \\).*/\\1no/' /etc/ssh/sshd_config",
      "sleep 5",
    ]

    connection {
      type        = "ssh"
      private_key = "${file("~/.ssh/id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }
  }

  # Copies the logrotate conf
  provisioner "file" {
    source      = "conf/bitcoin-logrotate"
    destination = "/etc/logrotate.d/bitcoin-debug"

    connection {
      type        = "ssh"
      private_key = "${file("~/.ssh/id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }
  }

  # Copies the systemd conf
  provisioner "file" {
    source      = "conf/bitcoin.service"
    destination = "/etc/systemd/system/multi-user.target.wants/bitcoind.service"

    connection {
      type        = "ssh"
      private_key = "${file("~/.ssh/id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir ~/.bitcoin",
      "echo 'prune=5000' >> ~/.bitcoin/bitcoin.conf",
    ]

    connection {
      type        = "ssh"
      private_key = "${file("~/.ssh/id_rsa")}"
      user        = "bitcoin"
      timeout     = "1m"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl daemon-reload",
      "systemctl restart bitcoind",
      "sudo ufw --force enable",
    ]

    connection {
      type        = "ssh"
      private_key = "${file("~/.ssh/id_rsa")}"
      user        = "root"
      timeout     = "2m"
    }
  }
}
