output "project" {
  description = "Project ID"
  value       = var.project
}

output "enabled_services" {
  description = "Enabled services"
  value       = [for service in google_project_service.default : service.service]
}

output "bucket_name" {
  description = "Cloud Storage Bucket name"
  value       = google_storage_bucket.site.name
}

output "folder_name" {
  description = "Managed folder name"
  value       = google_storage_managed_folder.public.name
}

output "upload_uri" {
  description = "gs:// upload URI"
  value       = "gs://${google_storage_bucket.site.name}/${google_storage_managed_folder.public.name}"
}

output "site_link" {
  description = "Static web site address"
  value       = "https://storage.googleapis.com/${google_storage_bucket.site.name}/${google_storage_managed_folder.public.name}index.html"
}

output "data_store_id" {
  description = "VAIS data store ID"
  value       = { for k, v in google_discovery_engine_data_store.unstructured : k => v.data_store_id }
}

output "search_engine_id" {
  description = "VAIS search engine ID"
  value       = google_discovery_engine_search_engine.generic.id
}

output "widget_console_page" {
  description = "Cloud console widget configuration page URI"
  value       = "https://console.cloud.google.com/gen-app-builder/locations/${var.vais_location}/engines/${google_discovery_engine_search_engine.generic.engine_id}/integration/widget?project=${var.project}"
}
