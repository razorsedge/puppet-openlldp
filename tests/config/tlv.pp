Exec { path => '/bin:/usr/bin:/sbin:/usr/sbin' }
include openlldp
openlldp::config::tlv { 'eth0':
  portDesc => 'yes',
  sysName  => 'yes',
  sysDesc  => 'yes',
  sysCap   => 'yes',
  mngAddr  => 'yes',
}
