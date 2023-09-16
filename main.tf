module "network" {
  source      = "./modules/network"
  vpccidr     = var.vpccidr
  vpctag      = var.vpctag
  pub_cidrs   = var.pub_cidrs
  pri_cidrs   = var.pri_cidrs
  azs         = var.azs
  pubtags     = var.pubtags
  pritags     = var.pritags
  pubtag      = var.pubtag
  pritag      = var.pritag
  allow-eip   = var.allow-eip
  environment = var.environment
}