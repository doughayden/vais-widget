resource "google_project_service" "default" {
  for_each           = toset(var.services)
  disable_on_destroy = false
  service            = each.key
}

resource "random_id" "suffix" {
  byte_length = 8

  keepers = {
    # Generate a new id when these values change
    bucket = var.bucket
  }
}

resource "google_storage_bucket" "site" {
  name                        = "${random_id.suffix.keepers.bucket}-${random_id.suffix.hex}"
  location                    = "US"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_managed_folder" "public" {
  bucket        = google_storage_bucket.site.name
  name          = "public/"
  force_destroy = true
}

resource "google_storage_managed_folder_iam_member" "public_viewer" {
  bucket         = google_storage_managed_folder.public.bucket
  managed_folder = google_storage_managed_folder.public.name
  role           = "roles/storage.objectViewer"
  member         = "allUsers"
}

resource "google_discovery_engine_data_store" "unstructured" {
  for_each                    = var.data_stores
  display_name                = each.value.data_store_id
  industry_vertical           = each.value.industry_vertical
  content_config              = each.value.content_config
  location                    = var.vais_location
  data_store_id               = each.value.data_store_id
  solution_types              = each.value.solution_types
  create_advanced_site_search = each.value.create_advanced_site_search

  document_processing_config {
    chunking_config {
      layout_based_chunking_config {
        chunk_size                = 500
        include_ancestor_headings = true
      }
    }
    default_parsing_config {
      layout_parsing_config {}
    }
  }
}

resource "google_discovery_engine_search_engine" "generic" {
  display_name      = var.search_engine.search_engine_id
  data_store_ids    = [for data_store in var.data_stores : data_store.data_store_id]
  engine_id         = var.search_engine.search_engine_id
  collection_id     = var.search_engine.collection_id
  location          = var.vais_location
  industry_vertical = var.search_engine.industry_vertical

  search_engine_config {
    search_add_ons = var.search_engine.search_add_ons
    search_tier    = var.search_engine.search_tier
  }

  common_config {
    company_name = var.search_engine.company_name
  }

  # Ensure the search engine is created after all data stores.
  depends_on = [google_discovery_engine_data_store.unstructured]

}
