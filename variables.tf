variable "tags" {
	type = map
	description = "A map of tags that will be merged with the "
	default = {}
}

variable "aws_subnets" {
	type = list(string)
	default = [
		"10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
	]
}
