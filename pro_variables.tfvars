environment = "pro"
vpccidr     = "172.19.0.0/16"
pub_cidrs   = ["172.19.0.0/19", "172.19.32.0/19", "172.19.64.0/19"]
pri_cidrs   = ["172.19.96.0/19", "172.19.128.0/19", "172.19.160.0/19"]
vpctag = {
  Name = "vpc-local"
  Env  = "pro"
}
