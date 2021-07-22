data "terraform_remote_state" "terraform-hcp-core" {
  backend = "remote"

  config = {
    organization = "grantorchard"
    workspaces = {
      name = "terraform-hcp-core"
    }
  }
}