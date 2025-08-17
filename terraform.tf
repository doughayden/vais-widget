terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.48.0, < 7.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.7.2, < 4.0.0"
    }
  }
  required_version = ">= 1.12.2"
}
