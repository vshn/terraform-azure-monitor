output "action_group_id" {
  description = "The ID of the Opsgenie action group"
  value       = azurerm_monitor_action_group.opsgenie.id
}
