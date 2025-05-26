
output "default_values" {
  description = "All default values."
  value       = local.defaults
}

output "model" {
  description = "Full model."
  value       = local.model
}

output "ospf_configurations_with_vrf" {
  value = local.ospf_configurations_with_vrf
}

output "ospf_configurations_without_vrf" {
  value = local.ospf_configurations_without_vrf
}
