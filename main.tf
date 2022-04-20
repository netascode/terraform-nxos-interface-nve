locals {
  vni_map              = { for v in var.vnis : v.vni => v }
  vni_map_with_ingress = { for v in var.vnis : v.vni => v if v.ingress_replication_protocol != null }
}

resource "nxos_nve_interface" "nvoEp" {
  admin_state                      = var.enabled ? "enabled" : "disabled"
  advertise_virtual_mac            = var.advertise_virtual_mac
  hold_down_time                   = var.hold_down_time
  host_reachability_protocol       = var.host_reachability_protocol
  ingress_replication_protocol_bgp = var.ingress_replication_protocol_bgp
  multicast_group_l2               = var.multicast_group_l2
  multicast_group_l3               = var.multicast_group_l3
  multisite_source_interface       = var.multisite_source_interface
  source_interface                 = var.source_interface
  suppress_arp                     = var.suppress_arp
  suppress_mac_route               = var.suppress_mac_route
}

resource "nxos_nve_vni_container" "nvoNws" {
  depends_on = [
    nxos_nve_interface.nvoEp
  ]
}

resource "nxos_nve_vni" "nvoNw" {
  for_each                       = local.vni_map
  vni                            = each.value.vni
  associate_vrf                  = each.value.associate_vrf
  multicast_group                = each.value.multicast_group
  multisite_ingrress_replication = each.value.multisite_ingrress_replication
  suppress_arp                   = each.value.suppress_arp

  depends_on = [
    nxos_nve_vni_container.nvoNws
  ]
}

resource "nxos_nve_vni_ingress_replication" "nvoIngRepl" {
  for_each = local.vni_map_with_ingress
  vni      = each.value.vni
  protocol = each.value.ingress_replication_protocol

  depends_on = [
    nxos_nve_vni.nvoNw
  ]
}
