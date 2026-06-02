variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into"
}

variable "action_group_name" {
  type        = string
  description = "Name of the Azure Monitor action group"
}

variable "action_group_short_name" {
  type        = string
  description = "Short name for the action group (max 12 characters)"
  validation {
    condition     = length(var.action_group_short_name) <= 12
    error_message = "action_group_short_name must be 12 characters or fewer."
  }
}

variable "webhook_url" {
  type        = string
  description = "Webhook URL for the action group receiver"
  sensitive   = true
}

variable "webhook_receiver_name" {
  type        = string
  description = "Display name for the webhook receiver in the action group"
}

variable "alerts" {
  type = map(object({
    description      = string
    scopes           = list(string)
    metric_namespace = string
    metric_name      = string
    aggregation      = string
    operator         = string
    threshold        = number
    severity         = optional(number, 2)
    window_size      = optional(string, "PT5M")
    frequency        = optional(string, "PT1M")
  }))
  description = "Map of metric alerts to create. The map key is used as the alert name."
  default     = {}
}
