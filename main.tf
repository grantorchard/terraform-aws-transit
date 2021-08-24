provider "aws" {
	region = local.hcp_region
	default_tags {
   tags = local.tags
 }
}

locals {
	tags = merge(var.tags, {
     owner       = "go"
		 se-region   = "apj"
		 purpose     = "hcp connectivity"
     ttl         = "-1"
		 terraform   = true
		 hc-internet-facing = false
   })
	hcp_account_id = data.terraform_remote_state.terraform-hcp-core.outputs.aws_account_id
	hcp_region = data.terraform_remote_state.terraform-hcp-core.outputs.hcp_hvn_region
	hcp_hvn_id = data.terraform_remote_state.terraform-hcp-core.outputs.hcp_hvn_id
	hcp_hvn_self_link = data.terraform_remote_state.terraform-hcp-core.outputs.hcp_hvn_self_link
	route_table_id = data.terraform_remote_state.aws-core.outputs.default_route_table_id
	subnet_ids = concat(data.terraform_remote_state.aws-core.outputs.private_subnets, data.terraform_remote_state.aws-core.outputs.public_subnets)
	vpc_id = data.terraform_remote_state.aws-core.outputs.vpc_id
}

resource "aws_ec2_transit_gateway" "this" {
	amazon_side_asn = 65001
	#auto_accept_shared_attachments = "enable"
	default_route_table_association = "enable"
	default_route_table_propagation = "enable"
	vpn_ecmp_support = "enable"
	dns_support = "enable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  subnet_ids         = local.subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = local.vpc_id
}

resource "aws_route" "hcp_vault" {
	transit_gateway_id = aws_ec2_transit_gateway.this.id
	destination_cidr_block = "172.25.16.0/24"
	route_table_id = local.route_table_id
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

resource "hcp_aws_transit_gateway_attachment" "this" {
  depends_on = [
    aws_ram_principal_association.this,
    aws_ram_resource_association.this,
  ]

  hvn_id                        = local.hcp_hvn_id
  transit_gateway_attachment_id = "hcp-tgw-attachment"
  transit_gateway_id            = aws_ec2_transit_gateway.this.id
  resource_share_arn            = aws_ram_resource_share.this.arn

}

# resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "this" {
#   transit_gateway_attachment_id = hcp_aws_transit_gateway_attachment.this.provider_transit_gateway_attachment_id
# }

resource "hcp_hvn_route" "route" {
	for_each = toset(var.aws_subnets)
  hvn_link         = local.hcp_hvn_self_link
  hvn_route_id     = "hcp-to-${replace(split("/", each.value)[0], ".", "-")}"
  destination_cidr = each.value
  target_link      = hcp_aws_transit_gateway_attachment.this.self_link
}