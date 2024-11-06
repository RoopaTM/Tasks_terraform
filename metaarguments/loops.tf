provider "random" {}

locals {
  names = ["abc", "def", "apple", "cat"]
}

resource "random_id" "example_id" {
  count = length(local.names) 
  byte_length = 9
}

resource "random_string" "example_string" {
  for_each = toset(local.names)
  length  = 16
  special = true
}


