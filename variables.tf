## Settings

variable "droplet_size" {
  description = "The droplet size [512mb, 1g, 2gb, 4gb, ...]"
  default     = "512mb"
}

variable "count_map" {
  description = "Define how many nodes are required per region"

  default = {
    "ams3" = 2
    "sfo2" = 2
    "sgp1" = 2
    "fra1" = 1
    "lon1" = 1
    "nyc3" = 1
    "blr1" = 1
  }
}

variable "total_count" {
  description = "Total sum of all the BTC nodes. Must be theright sum of node"
  default     = 10
}
