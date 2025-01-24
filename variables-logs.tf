variable "logs_destinations_ids" {
  type        = list(string)
  description = <<EOD
List of destination resources IDs for logs diagnostic destination.
Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.
If you want to use Azure EventHub as a destination, you must provide a formatted string containing both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the <code>&#124;</code> character.
EOD
}

variable "logs_categories" {
  type        = list(string)
  description = "Log categories to send to destinations."
  default     = null
}

variable "logs_metrics_categories" {
  type        = list(string)
  description = "Metrics categories to send to destinations."
  default     = null
}

variable "diagnostic_settings_custom_name" {
  description = "Custom name of the diagnostics settings, name will be 'default' if not set."
  type        = string
  default     = "default"
}
