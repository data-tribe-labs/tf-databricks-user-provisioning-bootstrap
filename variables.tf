variable "workspace_host" {
  type        = string
  description = "The host of the workspace"
}

variable "env" {
  type        = string
  description = "The environment"
  default     = "dev"
}


variable "databricks_account_id" {
  type        = string
  description = "The Databricks account ID"
  default     = "xxxxx"
}


variable "entra_group_name" {
  type        = string
  description = "The name of the Entra group"
  default     = "entra-group-name"
  nullable    = true
}


variable "metastore_id" {
  nullable    = false
  type        = string
  description = "The ID of the metastore"
  default     = "xxxxx"
}

variable "workspace_id" {
  nullable    = false
  type        = string
  description = "The ID of the workspace"
  default     = "xxxxx"
}