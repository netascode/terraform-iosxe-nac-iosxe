
output "default_values" {
  description = "All default values."
  value       = local.defaults
}

output "model" {
  description = "Full devices model."
  value       = local.iosxe_devices
}
