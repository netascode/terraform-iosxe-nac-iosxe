
output "default_values" {
  description = "All default values."
  value       = local.defaults
}

output "model" {
  description = "Full devices model."
  value       = local.iosxe_devices
}

output "devices" {
  description = "List of all devices."
  value       = local.all_devices
}
