terraform {
  required_providers {
    ncloud = {
      source = "navercloudplatform/ncloud"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  required_version = ">= 0.13"
}
