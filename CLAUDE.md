# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Vertex AI Search (VAIS) Widget demonstration project that uses Terraform to provision Google Cloud infrastructure for hosting a simple search widget on Google Cloud Storage. The project creates a static website that integrates with Google's Vertex AI Search capabilities.

## Architecture

For simplicity, the project uses a local Terraform backend and a flattened structure with all configuration files in the root directory. The main components are:

- **API Services**: Enables required Google Cloud APIs via `google_project_service` resources
- **Storage**: Creates a public GCS bucket with managed folder for hosting the HTML widget
- **Vertex AI Search**: Provisions data stores and search engines with configurable parameters

All Terraform resources are defined in a single `main.tf` file in the root directory, making the project structure simple and easy to understand.

## Key Files

- `main.tf`: Primary Terraform configuration containing all resources
- `variables.tf`: Variable definitions with sensible defaults for easy demo usage
- `outputs.tf`: Output values including bucket name, upload URI, and console links
- `providers.tf`: Provider configurations for Google Cloud and Random
- `terraform.tf`: Terraform version and provider requirements
- `terraform.tfvars`: Project-specific variable values
- `index.html`: HTML template for the Vertex AI Search widget
- `docs/manual_steps.md`: Comprehensive manual setup guide for Vertex AI Search configuration

## Key Commands

Deploy infrastructure:
```bash
terraform init
terraform plan
terraform apply
```

Open the widget configuration page in Chrome (macOS):
```bash
open -a "/Applications/Google Chrome.app" "$(terraform output -raw widget_console_page)"
```

Upload the search widget to the bucket:
```bash
gcloud storage cp index.html "$(terraform output -raw upload_uri)"
```

Open the static site hosting the widget in Chrome (macOS):
```bash
open -a "/Applications/Google Chrome.app" "$(terraform output -raw site_link)"
```

Destroy infrastructure:
```bash
terraform destroy
```

## Configuration

Key variables are defined in `variables.tf` with defaults and can be overridden in `terraform.tfvars`:
- `project`: GCP project ID (must be set in terraform.tfvars)
- `services`: List of Google Cloud APIs to enable (has sensible defaults)
- `bucket`: Base name for the GCS bucket (default: "vais-widget-demo")
- `vais_location`: Location for Vertex AI Search resources (default: "global")
- `data_stores`: Map of data store configurations with defaults
- `search_engine`: Search engine configuration object with defaults

## Bucket Naming

The project uses a `random_id` resource with keepers to generate unique bucket names:
- Base bucket name is defined in the `bucket` variable
- A random 8-byte hex suffix is appended: `${bucket}-${random_id.suffix.hex}`
- The random ID regenerates when the bucket variable changes
- Data stores and search engines use their configured IDs directly without random suffixes

## Widget Configuration

The search widget requires a `configId` value that must be obtained from the Google Cloud Console after setting up the Vertex AI Search engine. The `index.html` file contains a placeholder that needs to be replaced with the actual configuration ID.

## Terraform Outputs

After applying the Terraform configuration, several useful outputs are provided:
- `site_link`: Direct URL to access the hosted website
- `upload_uri`: GCS URI for uploading files to the public folder
- `widget_console_page`: Direct link to the Google Cloud Console widget configuration page
- `bucket_name`: The generated bucket name with random suffix
- `search_engine_id`: The ID of the created search engine

## Manual Setup Required

While Terraform creates the Vertex AI Search infrastructure, some manual configuration is still required. Follow the detailed steps in `docs/manual_steps.md` to:

1. Upload content to the created data store
2. Configure the search widget with proper domain allowlist in the Google Cloud Console
3. Obtain the `configId` value from the widget integration page and update `index.html`
4. Upload the configured HTML file to the GCS bucket

## Security Notes

- The GCS managed folder `/public/` is configured for public access (`allUsers` with `storage.objectViewer` role)
- This is intended for demonstration purposes only and should not be used in production
- The bucket itself uses uniform bucket-level access for simplified permissions management
- No authentication or access control is implemented for the static website