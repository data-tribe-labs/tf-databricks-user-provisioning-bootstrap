

# Create sandbox catalog and schemas

resource "databricks_catalog" "sandbox_catalog" {
  provider     = databricks.workspace_provider
  name         = "sandbox_${var.env}"
  metastore_id = var.metastore_id
}

resource "databricks_schema" "experiments_schema" {
  provider     = databricks.workspace_provider
  catalog_name = databricks_catalog.sandbox_catalog.name
  name         = "experiments"
}

resource "databricks_schema" "triage_schema" {
  provider     = databricks.workspace_provider
  catalog_name = databricks_catalog.sandbox_catalog.name
  name         = "triage"
}

# Catalog permissions for app_devs
resource "databricks_grants" "sandbox_catalog_app_devs" {
  provider = databricks.workspace_provider
  catalog  = databricks_catalog.sandbox_catalog.name

  grant {
    principal  = data.databricks_group.app_devs.display_name
    privileges = ["USE_CATALOG", "CREATE_SCHEMA"]
  }
}

# Experiments Schema permissions for app_devs
resource "databricks_grants" "grant_experiments_schema_to_app_devs" {
  provider = databricks.workspace_provider
  schema   = "${databricks_catalog.sandbox_catalog.name}.${databricks_schema.experiments_schema.name}"

  grant {
    principal  = data.databricks_group.app_devs.display_name
    privileges = ["USE_SCHEMA", "CREATE_TABLE", "CREATE_FUNCTION", "CREATE_VOLUME"]
  }
}

# Triage Schema permissions for app_devs
resource "databricks_grants" "grant_triage_schema_to_app_devs" {
  provider = databricks.workspace_provider
  schema   = "${databricks_catalog.sandbox_catalog.name}.${databricks_schema.triage_schema.name}"

  grant {
    principal  = data.databricks_group.app_devs.display_name
    privileges = ["USE_SCHEMA", "CREATE_TABLE", "CREATE_FUNCTION", "CREATE_VOLUME"]
  }
}
