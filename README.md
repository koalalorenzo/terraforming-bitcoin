# Terraform Bitcoin nodes on Digitalocean
Easy terraform setup for Bitcoin nodes on DigitalOcean.

There are different branches each one related to different clients and providers.

 * `do/bitcoin-unlimited`: Bitcoin Unlimited on DigitalOcean
 * `do/bitcoin-classic`: Bitcoin Classic on DigitalOcean
 * `do/bitcoin-core`: Bitcoin Core on DigitalOcean

Feel free to change the code and create Pull requests to support multiple providers,
client versions, and remember: peaceful diversity is the way to survive!

## Requirements
To start using this tool you need [Terraform](https://www.terraform.io) installed. On macOS with `homebrew` installed you can simply run:

```
$ brew install terraform
```

You will also need a **DigitalOcean API key**. You can generate one [here](https://cloud.digitalocean.com/settings/api/tokens), and remember to provide both `read` and `write` permissions.

## How to configure
Terraform will ask specific tokens that are missing (Like the DigitalOcean Token), but it is possible to change the amount of nodes or their size by modifying the file called `variables.tf`.

For example, to deploy 3 nodes in `nyc` and 2 in `ams` e 2 in `sgp` you can modify `count_map` and `total_count` like the following:

```
[...]
variable "count_map" {
  description = "Define how many nodes are required per region"

  default = {
    "sgp1" = 4
    "nyc3" = 2
    "ams3" = 2
  }
}

variable "total_count" {
  description = "Total sum of all the BTC nodes. Must be theright sum of node"
  default     = 8
}
[...]
```

It is Important that:

1. `total_count` is updated correctly with the total quantity of nodes
2. `count_map` is not filled with `"ams3" = 0` values, instead those has to be deleted

If needed, it is possible also to enable the **Status Cake** support, by uncommenting the lines in `variables.tf`, `providers.tf` and `status-cake.tf`.

It is possible also, to use environmental variables to set up tokents, but the code has to be modified accordingly.

`root` access via SSH/mosh is enabled by default, but it is possible to uncomment a line in `nodes.tf` to disable it.

## How to run
Clone this repository and then you can get an overview of what will be executed by running

```
$ terraform plan
```

If the planned changes are what you wanted, you can apply them by using the following command:

```
$ terraform apply
```

_Farite!_ When completed you should see a list of IPs of your nodes. You can check if everything is fine by running:

```
ssh bitcoin@[IP HERE] bitcoin-cli getinfo
```