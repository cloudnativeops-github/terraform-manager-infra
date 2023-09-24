environment = "dev"
vpccidr     = "172.17.0.0/16"
pub_cidrs   = ["172.17.0.0/19", "172.17.32.0/19", "172.17.64.0/19"]
pri_cidrs   = ["172.17.96.0/19", "172.17.128.0/19", "172.17.160.0/19"]
vpctag = {
  Name = "vpc-local"
  Env  = "dev"
}
