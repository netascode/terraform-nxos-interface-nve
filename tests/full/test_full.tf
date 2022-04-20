terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    nxos = {
      source  = "netascode/nxos"
      version = ">=0.3.5"
    }
  }
}

# requirement
resource "nxos_feature_bgp" "bgp" {
  admin_state = "enabled"
}

resource "nxos_feature_nv_overlay" "nvo" {
  admin_state = "enabled"
}

resource "nxos_feature_evpn" "evpn" {
  admin_state = "enabled"
  depends_on = [
    nxos_feature_nv_overlay.nvo
  ]
}

module "main" {
  source = "../.."

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

  depends_on = [
    nxos_feature_evpn.evpn
  ]
}

data "nxos_rest" "nxos_nve_interface" {
  dn = "sys/eps/epId-[1]"

  depends_on = [module.main]
}

resource "test_assertions" "nxos_nve_interface" {
  component = "nxos_nve_interface"

  equal "adminSt" {
    description = "adminSt"
    got         = data.nxos_rest.nxos_nve_interface.content.adminSt
    want        = "enabled"
  }

  equal "advertiseVmac" {
    description = "advertiseVmac"
    got         = data.nxos_rest.nxos_nve_interface.content.advertiseVmac
    want        = "yes"
  }

  equal "holdDownTime" {
    description = "holdDownTime"
    got         = data.nxos_rest.nxos_nve_interface.content.holdDownTime
    want        = "123"
  }

  equal "hostReach" {
    description = "hostReach"
    got         = data.nxos_rest.nxos_nve_interface.content.hostReach
    want        = "bgp"
  }

  equal "ingressReplProtoBGP" {
    description = "hostReach"
    got         = data.nxos_rest.nxos_nve_interface.content.ingressReplProtoBGP
    want        = "yes"
  }

  equal "multisiteBordergwInterface" {
    description = "multisiteBordergwInterface"
    got         = data.nxos_rest.nxos_nve_interface.content.multisiteBordergwInterface
    want        = "unspecified"
  }

  equal "sourceInterface" {
    description = "sourceInterface"
    got         = data.nxos_rest.nxos_nve_interface.content.sourceInterface
    want        = "lo0"
  }

  equal "suppressARP" {
    description = "suppressARP"
    got         = data.nxos_rest.nxos_nve_interface.content.suppressARP
    want        = "yes"
  }

  equal "suppressMacRoute" {
    description = "suppressMacRoute"
    got         = data.nxos_rest.nxos_nve_interface.content.suppressMacRoute
    want        = "yes"
  }
}


data "nxos_rest" "nxos_nve_vni_12" {
  dn = "sys/eps/epId-[1]/nws/vni-[12]"

  depends_on = [module.main]
}

resource "test_assertions" "nxos_nve_vni_12" {
  component = "nxos_nve_vni_12"

  equal "associateVrfFlag" {
    description = "associateVrfFlag"
    got         = data.nxos_rest.nxos_nve_vni_12.content.associateVrfFlag
    want        = "no"
  }

  equal "mcastGroup" {
    description = "mcastGroup"
    got         = data.nxos_rest.nxos_nve_vni_12.content.mcastGroup
    want        = "239.1.1.1"
  }

  equal "multisiteIngRepl" {
    description = "multisiteIngRepl"
    got         = data.nxos_rest.nxos_nve_vni_12.content.multisiteIngRepl
    want        = "disable"
  }

  equal "suppressARP" {
    description = "suppressARP"
    got         = data.nxos_rest.nxos_nve_vni_12.content.suppressARP
    want        = "off"
  }

  equal "vni" {
    description = "vni"
    got         = data.nxos_rest.nxos_nve_vni_12.content.vni
    want        = "12"
  }
}

data "nxos_rest" "nxos_nve_vni_13" {
  dn = "sys/eps/epId-[1]/nws/vni-[13]"

  depends_on = [module.main]
}

resource "test_assertions" "nxos_nve_vni_13" {
  component = "nxos_nve_vni_13"

  equal "associateVrfFlag" {
    description = "associateVrfFlag"
    got         = data.nxos_rest.nxos_nve_vni_13.content.associateVrfFlag
    want        = "no"
  }

  equal "mcastGroup" {
    description = "mcastGroup"
    got         = data.nxos_rest.nxos_nve_vni_13.content.mcastGroup
    want        = "0.0.0.0"
  }

  equal "multisiteIngRepl" {
    description = "multisiteIngRepl"
    got         = data.nxos_rest.nxos_nve_vni_13.content.multisiteIngRepl
    want        = "disable"
  }

  equal "suppressARP" {
    description = "suppressARP"
    got         = data.nxos_rest.nxos_nve_vni_13.content.suppressARP
    want        = "enabled"
  }

  equal "vni" {
    description = "vni"
    got         = data.nxos_rest.nxos_nve_vni_13.content.vni
    want        = "13"
  }
}

data "nxos_rest" "nxos_nve_vni_13_ir" {
  dn = "sys/eps/epId-[1]/nws/vni-[13]/IngRepl"

  depends_on = [module.main]
}

resource "test_assertions" "nxos_nve_vni_13_ir" {
  component = "nxos_nve_vni_13_ir"

  equal "proto" {
    description = "proto"
    got         = data.nxos_rest.nxos_nve_vni_13_ir.content.proto
    want        = "bgp"
  }
}
