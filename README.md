<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-nxos-interface-nve/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-nxos-interface-nve/actions/workflows/test.yml)

# Terraform NX-OS NVE Interface Module

Manages NX-OS NVE Interface

Model Documentation: [Link](https://developer.cisco.com/docs/cisco-nexus-3000-and-9000-series-nx-api-rest-sdk-user-guide-and-api-reference-release-9-3x/#!configuring-nve-interfaces)

## Examples

```hcl
module "nxos_interface_nve" {
  source  = "netascode/interface-nve/nxos"
  version = ">= 0.0.1"

  admin_state                      = true
  advertise_virtual_mac            = true
  hold_down_time                   = 123
  host_reachability_protocol       = "bgp"
  ingress_replication_protocol_bgp = true
  source_interface                 = "lo0"
  suppress_arp                     = true
  suppress_mac_route               = true
  vnis = [
    {
      vni           = 10
      associate_vrf = true
    },
    {
      vni           = 11
      associate_vrf = true
    },
    {
      vni             = 12
      multicast_group = "239.1.1.1"
    },
    {
      vni                          = 13
      ingress_replication_protocol = "bgp"
      suppress_arp                 = "enabled"
    },
    {
      vni                          = 14
      ingress_replication_protocol = "unknown"
    }
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_nxos"></a> [nxos](#requirement\_nxos) | >= 0.3.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nxos"></a> [nxos](#provider\_nxos) | >= 0.3.5 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_device"></a> [device](#input\_device) | A device name from the provider configuration. | `string` | `null` | no |
| <a name="input_admin_state"></a> [admin\_state](#input\_admin\_state) | Administrative port state. Set `true` for `up` or `false` for `down`. | `bool` | `false` | no |
| <a name="input_advertise_virtual_mac"></a> [advertise\_virtual\_mac](#input\_advertise\_virtual\_mac) | Enable or disable Virtual MAC Advertisement in VPC mode. | `bool` | `false` | no |
| <a name="input_hold_down_time"></a> [hold\_down\_time](#input\_hold\_down\_time) | Hold Down Time. | `number` | `180` | no |
| <a name="input_host_reachability_protocol"></a> [host\_reachability\_protocol](#input\_host\_reachability\_protocol) | Host Reachability Protocol. Choices: `Flood-and-learn`, `bgp`, `controller`, `openflow`, `openflowIR`. | `string` | `"Flood-and-learn"` | no |
| <a name="input_ingress_replication_protocol_bgp"></a> [ingress\_replication\_protocol\_bgp](#input\_ingress\_replication\_protocol\_bgp) | Enable or disable VxLAN Ingress Replication Protocol BGP. | `bool` | `false` | no |
| <a name="input_multicast_group_l2"></a> [multicast\_group\_l2](#input\_multicast\_group\_l2) | Base multicast group address for L2. | `string` | `"0.0.0.0"` | no |
| <a name="input_multicast_group_l3"></a> [multicast\_group\_l3](#input\_multicast\_group\_l3) | Base multicast group address for L3. | `string` | `"0.0.0.0"` | no |
| <a name="input_multisite_source_interface"></a> [multisite\_source\_interface](#input\_multisite\_source\_interface) | Multisite Border Gateway source interface. Must match first field in the output of `show int brief`. Example: `lo100`. | `string` | `"unspecified"` | no |
| <a name="input_source_interface"></a> [source\_interface](#input\_source\_interface) | Multisite Border Gateway source interface. Must match first field in the output of `show int brief`. Example: `lo1`. | `string` | `"unspecified"` | no |
| <a name="input_suppress_arp"></a> [suppress\_arp](#input\_suppress\_arp) | Enable or disable suppress ARP. | `bool` | `false` | no |
| <a name="input_suppress_mac_route"></a> [suppress\_mac\_route](#input\_suppress\_mac\_route) | Enable or disable suppress MAC Route. | `bool` | `false` | no |
| <a name="input_vnis"></a> [vnis](#input\_vnis) | List of vnis. Default value `associate_vrf`: `false`. Default value `multicast_group`: `0.0.0.0`. Choices `multisite_ingrress_replication`: `enable`, `disable`, `enableOptimized`. Default value `multisite_ingrress_replication`: `disable`. Choices `suppress_arp`: `enabled`, `disabled`, `off`. Default value `suppress_arp`: `off`. Choices `ingress_replication_protocol`: `bgp`, `static`, `unknown`. Default value `ingress_replication_protocol`: `unknown`. | <pre>list(object({<br>    vni                            = number<br>    associate_vrf                  = optional(bool)<br>    multicast_group                = optional(string)<br>    multisite_ingrress_replication = optional(string)<br>    suppress_arp                   = optional(string)<br>    ingress_replication_protocol   = optional(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of the object. |

## Resources

| Name | Type |
|------|------|
| [nxos_nve_interface.nvoEp](https://registry.terraform.io/providers/netascode/nxos/latest/docs/resources/nve_interface) | resource |
| [nxos_nve_vni.nvoNw](https://registry.terraform.io/providers/netascode/nxos/latest/docs/resources/nve_vni) | resource |
| [nxos_nve_vni_container.nvoNws](https://registry.terraform.io/providers/netascode/nxos/latest/docs/resources/nve_vni_container) | resource |
| [nxos_nve_vni_ingress_replication.nvoIngRepl](https://registry.terraform.io/providers/netascode/nxos/latest/docs/resources/nve_vni_ingress_replication) | resource |
<!-- END_TF_DOCS -->