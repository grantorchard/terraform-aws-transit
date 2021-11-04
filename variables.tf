variable "aws_subnets" {
	type = list(string)
	default = [
		"10.0.0.0/16"
	]
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