variable "project" {
  type        = string
  description = "Project ID"
}

variable "services" {
  type        = list(string)
  description = "Services to enable"
  default = [
    "discoveryengine.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com"
  ]
}

variable "bucket" {
  type        = string
  description = "Cloud Storage Bucket name"
  default     = "vais-widget-demo"
}

variable "vais_location" {
  type        = string
  description = "VAIS resource location"
  default     = "global"
}

variable "data_stores" {
  type = map(object({
    data_store_id               = string
    industry_vertical           = string
    content_config              = string
    solution_types              = list(string)
    create_advanced_site_search = bool
  }))
  description = "VAIS data stores"
  default = {
    vais-widget-demo = {
      data_store_id               = "vais-widget-demo"
      industry_vertical           = "GENERIC"
      content_config              = "CONTENT_REQUIRED"
      solution_types              = ["SOLUTION_TYPE_SEARCH"]
      create_advanced_site_search = false
    }
  }
}

variable "search_engine" {
  type = object({
    search_engine_id  = string
    collection_id     = string
    industry_vertical = string
    search_add_ons    = list(string)
    search_tier       = string
    company_name      = string
  })
  description = "VAIS search engine"
  default = {
    search_engine_id  = "vais-widget-demo"
    collection_id     = "default_collection"
    industry_vertical = "GENERIC"
    search_add_ons    = ["SEARCH_ADD_ON_LLM"]
    search_tier       = "SEARCH_TIER_ENTERPRISE"
    company_name      = "Alphabet"
  }
}
