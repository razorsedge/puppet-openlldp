# == Define: openlldp::config::lldp
#
# Manages the sending and/or receiving of LLDP frames via the Open-LLDP
# software.
# http://www.open-lldp.org/
#
# === Parameters:
#
# [*title*]
#   The name of the Ethernet interface on which to transmit and/or
#   receive LLDP TLVs. (Ex: eth0, em1)  Bonding interfaces are not supported.
#
# [*adminstatus*]
#   Whether to receive, transmit, both receive and transmit, or ignore
#   LLDP frames on the given interface. tx or rxtx is required in order for
#   the transmittlv property to work.
#   Values: disabled, rx, tx, rxtx
#   Default: none
#
# [*bridgescope*]
#   Specify the bridge scope upon which to operate.
#   Values: nearest_bridge (nb), nearest_customer_bridge (ncb),
#     nearest_nontpmr_bridge (nntpmrb)
#   Default: nb
#
# === Actions:
#
# Configures Open-LLDP via lldptool to transmit and/or receive LLDP frames on
# given interfaces.
#
# === Sample Usage:
#
#  openlldp::config::lldp { 'eth0':
#    adminstatus => 'rxtx',
#    bridgescope => 'nb',
#  }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
define openlldp::config::lldp (
  $adminstatus,
  $bridgescope = 'nb'
) {
  Class['openlldp'] -> Openlldp::Config::Lldp[$title]

  $interface = $title
  $states = [ '^disabled$', '^rx$', '^tx$', '^rxtx$' ]
  validate_re($adminstatus, $states, '$adminstatus parameter must be disabled, rx, tx, or rxtx.')
  case $bridgescope {
    /^(nearest_bridge|nb)$/: {
      $scope = '-g nb'
    }
    /^(nearest_customer_bridge|ncb)$/: {
      $scope = '-g ncb'
    }
    /^(nearest_nontpmr_bridge|nntpmrb)$/: {
      $scope = '-g nntpmrb'
    }
    default: {
      fail('$bridgescope parameter must be nearest_bridge, nb, nearest_customer_bridge, ncb, nearest_nontpmr_bridge, or nntpmrb.')
    }
  }

  exec { "set-lldp ${interface}" :
    # /bin/grep & /usr/sbin/lldptool
    path    => ['/bin', '/usr/sbin'],
    command => "lldptool set-lldp -i ${interface} ${scope} adminStatus=${adminstatus}",
    onlyif  => "lldptool get-lldp -i ${interface} ${scope} adminStatus | grep -qv adminStatus=${adminstatus}$",
  }
}
