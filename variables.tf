variable "aws_subnets" {
<<<<<<< HEAD
	type = list(string)
	default = [
		"10.0.0.0/16"
	]
=======
  type = list(string)
                     //    SG ingress rules
  default = [        // consul, vault, default
    "10.0.101.0/24", //     23,     8,       1
    "10.0.102.0/24", //     31,    10,       1
    "10.0.103.0/24", //     39,    12,       1
    "10.0.1.0/24",   //     47,    14,       1
    "10.0.2.0/24",   //     55,    16,       1
    "10.0.3.0/24"    //     63,    18,       1 <--- over default limit of 60
  ]
>>>>>>> 24e2a14751a4e8dd1cf06f6cf20e0967d44a6560
}

variable "gcp_subnets" {
  type = list(string)

  default = [
    "172.16.0.0/21"
  ]
}

variable "owner" {
	type = string
}

variable "se-region" {
	type = string
}

variable "purpose" {
	type = string
}

variable "ttl" {
	type = number
}

variable "terraform" {
	type = bool
}

variable "hc-internet-facing" {
	type = bool
}