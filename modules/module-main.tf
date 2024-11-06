module "a1" {
  source = "./config"
  f1    = "a1.txt"
  r1    = 10
}
module "a2" {
  source = "./config"
  f1    = "a2.txt"
  r1    = 30
}

