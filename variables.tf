variable "admin_state" {
  description = "Administrative port state. Set `true` for `up` or `false` for `down`."
  type        = bool
  default     = false
}

variable "advertise_virtual_mac" {
  description = "Enable or disable Virtual MAC Advertisement in VPC mode."
  type        = bool
  default     = false
}

variable "hold_down_time" {
  description = "Hold Down Time."
  type        = number
  default     = 180

  validation {
    condition     = try(var.hold_down_time >= 1 && var.hold_down_time <= 1500, false)
    error_message = "Minimum value: `1`. Maximum value: `1500`."
  }
}

variable "host_reachability_protocol" {
  description = "Host Reachability Protocol. Choices: `Flood-and-learn`, `bgp`, `controller`, `openflow`, `openflowIR`."
  type        = string
  default     = "Flood-and-learn"

  validation {
    condition     = contains(["Flood-and-learn", "bgp", "controller", "openflow", "openflowIR"], var.host_reachability_protocol)
    error_message = "Allowed values are: `Flood-and-learn`, `bgp`, `controller`, `openflow` or `openflowIR`."
  }
}

variable "ingress_replication_protocol_bgp" {
  description = "Enable or disable VxLAN Ingress Replication Protocol BGP."
  type        = bool
  default     = false
}

variable "multicast_group_l2" {
  description = "Base multicast group address for L2."
  type        = string
  default     = "0.0.0.0"

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", var.multicast_group_l2))
    error_message = "`multicast_group`: Allowed format: `239.1.1.1`."
  }
}

variable "multicast_group_l3" {
  description = "Base multicast group address for L3."
  type        = string
  default     = "0.0.0.0"

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", var.multicast_group_l3))
    error_message = "`multicast_group`: Allowed format: `239.1.1.1`."
  }
}

variable "multisite_source_interface" {
  description = "Multisite Border Gateway source interface. Must match first field in the output of `show int brief`. Example: `lo100`."
  type        = string
  default     = "unspecified"

  validation {
    condition     = can(regex("^\\S*$", var.multisite_source_interface))
    error_message = "Whitespaces are not allowed. Must match first field in the output of `show int brief`. Example: `lo100`."
  }
}

variable "source_interface" {
  description = "Multisite Border Gateway source interface. Must match first field in the output of `show int brief`. Example: `lo1`."
  type        = string
  default     = "unspecified"

  validation {
    condition     = can(regex("^\\S*$", var.source_interface))
    error_message = "Whitespaces are not allowed. Must match first field in the output of `show int brief`. Example: `lo1`."
  }
}

variable "suppress_arp" {
  description = "Enable or disable suppress ARP."
  type        = bool
  default     = false
}

variable "suppress_mac_route" {
  description = "Enable or disable suppress MAC Route."
  type        = bool
  default     = false
}

variable "vnis" {
  description = "List of vnis. Default value `associate_vrf`: `false`. Default value `multicast_group`: `0.0.0.0`. Choices `multisite_ingrress_replication`: `enable`, `disable`, `enableOptimized`. Default value `multisite_ingrress_replication`: `disable`. Choices `suppress_arp`: `enabled`, `disabled`, `off`. Default value `suppress_arp`: `off`. Choices `ingress_replication_protocol`: `bgp`, `static`, `unknown`. Default value `ingress_replication_protocol`: `unknown`."
  type = list(object({
    vni                            = number
    associate_vrf                  = optional(bool)
    multicast_group                = optional(string)
    multisite_ingrress_replication = optional(string)
    suppress_arp                   = optional(string)
    ingress_replication_protocol   = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for v in var.vnis : try(v.vni >= 1 && v.vni <= 16777214, false)
    ])
    error_message = "`vni`: Minimum value: `1`. Maximum value: `16777214`."
  }


  validation {
    condition = alltrue([
      for v in var.vnis : can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", v.multicast_group)) || v.multicast_group == null
    ])
    error_message = "`multicast_group`: Allowed format: `239.1.1.1`."
  }

  validation {
    condition = alltrue([
      for v in var.vnis : try(contains(["enable", "disable", "enableOptimized"], v.multisite_ingrress_replication), v.multisite_ingrress_replication == null)
    ])
    error_message = "`multisite_ingrress_replication`: Allowed values are: `enable`, `disable` or `enableOptimized`."
  }

  validation {
    condition = alltrue([
      for v in var.vnis : try(contains(["enabled", "disabled", "off"], v.suppress_arp), v.suppress_arp == null)
    ])
    error_message = "`suppress_arp`: Allowed values are: `enabled`, `disabled` or `off`."
  }

  validation {
    condition = alltrue([
      for v in var.vnis : try(contains(["bgp", "static", "unknown"], v.ingress_replication_protocol), v.ingress_replication_protocol == null)
    ])
    error_message = "`ingress_replication_protocol`: Allowed values are: `bgp`, `static` or `unknown`."
  }
}
