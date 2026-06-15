# monitoring

Creates Azure Monitor metric alerts and routes them to a configurable webhook (e.g. Opsgenie, PagerDuty, custom endpoint).

## Usage

```hcl
module "monitoring" {
  source = "./modules/monitoring"

  resource_group_name     = azurerm_resource_group.rg_cluster.name
  action_group_name       = "${terraform.workspace}-alerts"
  action_group_short_name = "alerts"
  webhook_url             = var.monitoring_webhook_url
  webhook_receiver_name   = var.monitoring_webhook_receiver_name

  alerts = {
    "postgres-storage-warning" = {
      description      = "PostgreSQL storage usage above 80%"
      scopes           = [module.avm-postgresql-flexibleserver["server"].resource_id]
      metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
      metric_name      = "storage_percent"
      aggregation      = "Average"
      operator         = "GreaterThan"
      threshold        = 80
      severity         = 2
      tags             = { label = "OnCall" }
    }
  }
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `resource_group_name` | `string` | — | Resource group to deploy into. |
| `action_group_name` | `string` | — | Name of the Azure Monitor action group. |
| `action_group_short_name` | `string` | — | Short name for the action group (max 12 characters). |
| `webhook_url` | `string` | — | Webhook URL for the action group receiver. Sensitive. |
| `webhook_receiver_name` | `string` | — | Display name for the webhook receiver in the action group. |
| `alerts` | `map(object)` | `{}` | Map of metric alerts to create. The map key is used as the alert name. |

### Alert object attributes

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `description` | `string` | — | Human-readable description of the alert. |
| `scopes` | `list(string)` | — | List of resource IDs to monitor. |
| `metric_namespace` | `string` | — | Azure resource namespace, e.g. `Microsoft.DBforPostgreSQL/flexibleServers`. |
| `metric_name` | `string` | — | Metric to evaluate, e.g. `storage_percent`. |
| `aggregation` | `string` | — | Aggregation type: `Average`, `Count`, `Maximum`, `Minimum`, `Total`. |
| `operator` | `string` | — | Comparison operator: `GreaterThan`, `LessThan`, `GreaterThanOrEqual`, `LessThanOrEqual`, `Equals`. |
| `threshold` | `number` | — | Threshold value that triggers the alert. |
| `severity` | `number` | `2` | Alert severity 0–4 (0 = critical, 4 = verbose). |
| `window_size` | `string` | `PT5M` | Evaluation window in ISO 8601 duration format. |
| `frequency` | `string` | `PT1M` | Evaluation frequency in ISO 8601 duration format. |
| `tags` | `map(string)` | `{}` | Tags to apply to the alert rule, e.g. `{ label = "OnCall" }`. |

## Outputs

| Name | Description |
|------|-------------|
| `action_group_id` | The ID of the action group. Useful for attaching additional alerts outside this module. |
