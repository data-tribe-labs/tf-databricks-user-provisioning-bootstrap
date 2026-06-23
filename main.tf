terraform {
  required_version = ">= 1.15.6"

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.118.0"
    }
  }
}

# ---- Provider 1: ACCOUNT level (identity, groups, entitlements) ----
provider "databricks" {
  alias      = "account_provider"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
}

# ---- Provider 2: WORKSPACE level (Unity Catalog, compute) ----
provider "databricks" {
  alias = "workspace_provider"
  host  = var.workspace_host
}

# Option 1: If Entra SCIM CREATES the groups, reference them instead with a data source:

# If Entra SCIM CREATES the groups, reference them instead with a data source:
#   data "databricks_group" "app_devs" { display_name = "app-devs" }

# OR 

# Option 2: If you want to create the groups in Terraform, declare them as resources:

# resource "databricks_group" "app_devs" {
#   provider     = databricks.account_provider
#   display_name = "developer_group_${var.env}"
# }


resource "databricks_sql_endpoint" "shared_warehouse" {
  provider         = databricks.workspace_provider
  name             = "shared_warehouse_${var.env}"
  cluster_size     = "X-Small"
  max_num_clusters = 1
}

resource "databricks_permissions" "warehouse" {
  provider        = databricks.workspace_provider
  sql_endpoint_id = databricks_sql_endpoint.shared_warehouse.id

  access_control {
    group_name       = data.databricks_group.app_devs.display_name
    permission_level = "CAN_USE"
  }
}