terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    nxos = {
      source  = "netascode/nxos"
      version = ">=0.3.4"
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

  depends_on = [
    nxos_feature_evpn.evpn
  ]
}

data "nxos_rest" "nxos_nve_interface" {
  dn = "sys/eps/epId-[1]"

  depends_on = [module.main]
}

resource "test_assertions" "nxos_nve_interface" {
  component = "nxos_vnxos_nve_interfacerf"

  equal "adminSt" {
    description = "adminSt"
    got         = data.nxos_rest.nxos_nve_interface.content.adminSt
    want        = "disabled"
  }

  equal "advertiseVmac" {
    description = "advertiseVmac"
    got         = data.nxos_rest.nxos_nve_interface.content.advertiseVmac
    want        = "no"
  }

  equal "holdDownTime" {
    description = "holdDownTime"
    got         = data.nxos_rest.nxos_nve_interface.content.holdDownTime
    want        = "180"
  }

  equal "hostReach" {
    description = "hostReach"
    got         = data.nxos_rest.nxos_nve_interface.content.hostReach
    want        = "Flood-and-learn"
  }

  equal "ingressReplProtoBGP" {
    description = "hostReach"
    got         = data.nxos_rest.nxos_nve_interface.content.ingressReplProtoBGP
    want        = "no"
  }

  equal "multisiteBordergwInterface" {
    description = "multisiteBordergwInterface"
    got         = data.nxos_rest.nxos_nve_interface.content.multisiteBordergwInterface
    want        = "unspecified"
  }

  equal "sourceInterface" {
    description = "sourceInterface"
    got         = data.nxos_rest.nxos_nve_interface.content.sourceInterface
    want        = "unspecified"
  }

  equal "suppressARP" {
    description = "suppressARP"
    got         = data.nxos_rest.nxos_nve_interface.content.suppressARP
    want        = "no"
  }

  equal "suppressMacRoute" {
    description = "suppressMacRoute"
    got         = data.nxos_rest.nxos_nve_interface.content.suppressMacRoute
    want        = "no"
  }
}
