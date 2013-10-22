# == Define: openlldp::config::tlv
#
# Manages the sending of LLDP frames with specified TLVs via the Open-LLDP
# software.
# http://www.open-lldp.org/
#
# === Parameters:
#
# [*title*]
#   The name of the Ethernet interface on which to transmit LLDP TLVs. (Ex:
#   eth0, em1)  Bonding interfaces are not supported.
#
# [*portDesc*]
#   Whether to transmit the Port Description TLV (Type = 4).
#   Default: no
#
# [*sysName*]
#   Whether to transmit the System Name TLV (Type = 5).
#   Default: no
#
# [*sysDesc*]
#   Whether to transmit the System Description TLV (Type = 6).
#   Default: no
#
# [*sysCap*]
#   Whether to transmit the System Capabilities TLV (Type = 7).
#   Default: no
#
# [*mngAddr*]
#   Whether to transmit the Management Address TLV (Type = 8).
#   Default: no
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
#  openlldp::config::tlv { 'eth0':
#    portDesc => 'yes',
#    sysName  => 'yes',
#    sysDesc  => 'yes',
#    sysCap   => 'yes',
#    mngAddr  => 'yes',
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
define openlldp::config::tlv (
  $portDesc    = 'no',
  $sysName     = 'no',
  $sysDesc     = 'no',
  $sysCap      = 'no',
  $mngAddr     = 'no',
#  $macPhyCfg   = 'no',
#  $powerMdi    = 'no',
#  $linkAgg     = 'no',
#  $MTU         = 'no',
#  $PVID        = 'no',
  $bridgescope = 'nb'
) {
  Class['openlldp'] -> Openlldp::Config::Tlv[$title]

  $interface = $title
  $states = [ '^yes$', '^no$' ]
  validate_re($portDesc, $states, '$portDesc parameter must be yes or no.')
  validate_re($sysName,  $states, '$sysName parameter must be yes or no.')
  validate_re($sysDesc,  $states, '$sysDesc parameter must be yes or no.')
  validate_re($sysCap,   $states, '$sysCap parameter must be yes or no.')
  validate_re($mngAddr,  $states, '$mngAddr parameter must be yes or no.')
  #validate_re($status, $states, '$status parameter must be yes or no.')
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

  Exec {
    # /bin/grep & /usr/sbin/lldptool
    path => ['/bin', '/usr/sbin']
  }

  exec { "set-tlv ${interface} portDesc" :
    command => "lldptool set-tlv -i ${interface} ${scope} -V portDesc -c enableTx=${portDesc}",
    onlyif  => "lldptool get-tlv -i ${interface} ${scope} -V portDesc -c enableTx | grep -qv enableTx=${portDesc}",
  }
  exec { "set-tlv ${interface} sysName" :
    command => "lldptool set-tlv -i ${interface} ${scope} -V sysName -c enableTx=${sysName}",
    onlyif  => "lldptool get-tlv -i ${interface} ${scope} -V sysName -c enableTx | grep -qv enableTx=${sysName}",
  }
  exec { "set-tlv ${interface} sysDesc" :
    command => "lldptool set-tlv -i ${interface} ${scope} -V sysDesc -c enableTx=${sysDesc}",
    onlyif  => "lldptool get-tlv -i ${interface} ${scope} -V sysDesc -c enableTx | grep -qv enableTx=${sysDesc}",
  }
  exec { "set-tlv ${interface} sysCap" :
    command => "lldptool set-tlv -i ${interface} ${scope} -V sysCap -c enableTx=${sysCap}",
    onlyif  => "lldptool get-tlv -i ${interface} ${scope} -V sysCap -c enableTx | grep -qv enableTx=${sysCap}",
  }
  exec { "set-tlv ${interface} mngAddr" :
    command => "lldptool set-tlv -i ${interface} ${scope} -V mngAddr -c enableTx=${mngAddr}",
    onlyif  => "lldptool get-tlv -i ${interface} ${scope} -V mngAddr -c enableTx | grep -qv enableTx=${mngAddr}",
  }
#  exec { "set-tlv ${interface} status" :
#    command => "lldptool set-tlv -i ${interface} ${scope} -V status -c enableTx=${status}",
#    onlyif  => "lldptool get-tlv -i ${interface} ${scope} -V status -c enableTx | grep -qv enableTx=${status}",
#  }
}
