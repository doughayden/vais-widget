provider "google" {
  project               = var.project
  billing_project       = var.project
  user_project_override = true
}

provider "random" {}
