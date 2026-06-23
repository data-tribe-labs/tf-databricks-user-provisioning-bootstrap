
data "databricks_group" "app_devs" {
  provider     = databricks.account_provider
  display_name = var.entra_group_name
}

# Workspace entitlements for app_devs
resource "databricks_entitlements" "app_devs" {
  provider = databricks.account_provider
  group_id = data.databricks_group.app_devs.id

  workspace_access      = true # required: log in + attach notebooks to serverless compute
  databricks_sql_access = true # SQL warehouses / dashboards
  allow_cluster_create  = var.env == "dev" ? true : false
}

# this assigns the group to a workspace
resource "databricks_mws_permission_assignment" "app_devs" {
  provider     = databricks.account_provider
  workspace_id = var.workspace_id
  principal_id = data.databricks_group.app_devs.id
  permissions  = ["USER"]
}