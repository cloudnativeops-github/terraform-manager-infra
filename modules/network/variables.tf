variable "vpccidr" {
  type        = string
  description = "this variable for vpc cidr"
}

variable "vpctag" {
  description = "tagging the vpc"
  type = object({
    Name = string
    Env  = string
  })
}

variable "pub_cidrs" {
  type        = list(string)
  description = "this list of ip address used for public subnet"
}

variable "pri_cidrs" {
  type        = list(string)
  description = "this list of ip address used for private subnet"
}

variable "azs" {
  type        = list(string)
  description = "azs used for this deployment"
}

variable "pubtags" {
  type = list(object({
    Name = string
  }))
}

variable "pritags" {
  type = list(object({
    Name = string
  }))
}

variable "pubtag" {
  description = "tagging the vpc"
  type = object({
    Name = string
  })
}

variable "pritag" {
  description = "tagging the vpc"
  type = object({
    Name = string
  })
}

#variable "instance_type" {
#  type = string
#  description = "Install type it can be differ based on env"
#}

#variable "service_name" {
#  type = list(string)
#}
#
variable "allow-eip" {}

#variable "allow-list" {
#  type    = list(number)
#  default = [443]
#}
#
#variable "project" {}
variable "environment" {}