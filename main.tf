resource "azurerm_monitor_action_group" "this" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.action_group_short_name

  webhook_receiver {
    name                    = var.webhook_receiver_name
    service_uri             = var.webhook_url
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_metric_alert" "this" {
  for_each = var.alerts

  name                     = each.key
  resource_group_name      = var.resource_group_name
  scopes                   = each.value.scopes
  tags                     = each.value.tags
  target_resource_type     = each.value.target_resource_type
  target_resource_location = each.value.target_resource_location
  description              = each.value.description
  severity                 = each.value.severity
  window_size              = each.value.window_size
  frequency                = each.value.frequency

  criteria {
    metric_namespace = each.value.metric_namespace
    metric_name      = each.value.metric_name
    aggregation      = each.value.aggregation
    operator         = each.value.operator
    threshold        = each.value.threshold
  }

  action {
    action_group_id    = azurerm_monitor_action_group.this.id
    webhook_properties = each.value.webhook_properties
  }
}
