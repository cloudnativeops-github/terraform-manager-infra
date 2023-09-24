environment = "acc"
vpccidr     = "172.18.0.0/16"
pub_cidrs   = ["172.18.0.0/19", "172.18.32.0/19", "172.18.64.0/19"]
pri_cidrs   = ["172.18.96.0/19", "172.18.128.0/19", "172.18.160.0/19"]
vpctag = {
  Name = "vpc-local"
  Env  = "acc"
}
