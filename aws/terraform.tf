terraform {
  required_version = "1.17.0"

  cloud {
    organization = "travis-dev"

    workspaces {
      name = "example-terraform-cli"
    }
  }
}
