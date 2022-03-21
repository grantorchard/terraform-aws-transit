data "terraform_remote_state" "terraform-hcp-core" {
  backend = "remote"

  config = {
    organization = "grantorchard"
    workspaces = {
      name = "hcp-core"
    }
  }
}

data "terraform_remote_state" "aws-core" {
  backend = "remote"

  config = {
    organization = "grantorchard"
    workspaces = {
      name = "aws-core"
    }
  }
}
