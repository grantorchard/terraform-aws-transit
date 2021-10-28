variable "aws_subnets" {
  type = list(string)

  default = [
    "10.0.101.0/24", // 23, 8, 1 rules
    "10.0.102.0/24",
    # "10.0.103.0/24",
    # "10.0.1.0/24",
    # "10.0.2.0/24",
    # "10.0.3.0/24"
  ]
}

variable "gcp_subnets" {
  type = list(string)

  default = [
    "172.16.0.0/21"
  ]
}
