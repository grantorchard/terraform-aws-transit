provider "aws" {
	region = local.hcp_region
	default_tags {
   tags = {
     owner       = "go"
		 se-region   = "apj"
		 purpose     = "hcp connectivity"
     ttl         = "-1"
		 terraform   = true
		 hc-internet-facing = false
   }
 }
}

locals {
	hcp_account_id = data.terraform_remote_state.terraform-hcp-core.outputs.aws_account_id
	hcp_region = data.terraform_remote_state.terraform-hcp-core.outputs.hcp_hvn_region
}

resource "aws_ec2_transit_gateway" "this" {
  tags = {
    Name = "hcp-hvn"
  }
}

resource "aws_ram_resource_share" "this" {
  name                      = "hcp-hvn-resource-share"
  allow_external_principals = true
}

resource "aws_ram_principal_association" "this" {
  resource_share_arn = aws_ram_resource_share.this.arn
  principal          = local.hcp_account_id
}

resource "aws_ram_resource_association" "this" {
  resource_share_arn = aws_ram_resource_share.this.arn
  resource_arn       = aws_ec2_transit_gateway.this.arn
}
