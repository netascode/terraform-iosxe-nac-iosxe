variable "username" {
  description = "Username for the IOS-XE devices. Can also be set using the IOSXE_USERNAME environment variable."
  type        = string
  default     = null
}

variable "password" {
  description = "Password for the IOS-XE devices. Can also be set using the IOSXE_PASSWORD environment variable."
  type        = string
  default     = null
  sensitive   = true
}

variable "yaml_directories" {
  description = "List of paths to YAML directories."
  type        = list(string)
  default     = []
}

variable "yaml_files" {
  description = "List of paths to YAML files."
  type        = list(string)
  default     = []
}

variable "template_directories" {
  description = "List of paths to directories containing template files."
  type        = list(string)
  default     = []
}

variable "template_files" {
  description = "List of paths to template files."
  type        = list(string)
  default     = []
}

variable "model" {
  description = "As an alternative to YAML files, a native Terraform data structure can be provided as well."
  type        = map(any)
  default     = {}
}

variable "managed_device_groups" {
  description = "List of device group names to be managed. By default all device groups will be managed."
  type        = list(string)
  default     = []
}

variable "managed_devices" {
  description = "List of device names to be managed. By default all devices will be managed."
  type        = list(string)
  default     = []
}

variable "device_transaction" {
  description = "Enable device transaction mode. This will group all changes into a single transaction."
  type        = bool
  default     = false
}

variable "save_config" {
  description = "Write changes to startup-config on all devices."
  type        = bool
  default     = false
}

variable "write_model_file" {
  type        = string
  description = "Write the full model including all resolved templates to a single YAML file. Value is a path pointing to the file to be created."
  default     = ""
}
