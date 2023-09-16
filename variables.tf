variable "vpccidr" {
  type        = string
  default     = null
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
  default     = ["172.17.0.0/19", "172.17.32.0/19", "172.17.64.0/19"]
}

variable "pri_cidrs" {
  type        = list(string)
  description = "this list of ip address used for private subnet"
  default     = ["172.17.96.0/19", "172.17.128.0/19", "172.17.160.0/19"]
}

variable "azs" {
  type        = list(string)
  description = "azs used for this deployment"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "pubtags" {
  type = list(object({
    Name = string
  }))
  default = [
    {
      Name = "pub-1a"
    },
    {
      Name = "pub-1b"
    },
    {
      Name = "pub-1c"
    }
  ]
}

variable "pritags" {
  type = list(object({
    Name = string
  }))
  default = [
    {
      Name = "pri-1a"
    },
    {
      Name = "pri-1b"
    },
    {
      Name = "pri-1c"
    }
  ]
}

variable "pubtag" {
  description = "tagging the vpc"
  type = object({
    Name = string
  })
  default = {
    Name = "pub"
  }
}

variable "pritag" {
  description = "tagging the vpc"
  type = object({
    Name = string
  })
  default = {
    Name = "pri"
  }
}

variable "allow-eip" {
  type    = bool
  default = true
}

variable "environment" {
  type    = string
  default = null
}