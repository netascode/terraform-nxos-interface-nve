module "nxos_vrf" {
  source  = "netascode/interface-nve/nxos"
  version = ">= 0.0.1"

  enabled                          = true
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
