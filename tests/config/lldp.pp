Exec { path => '/bin:/usr/bin:/sbin:/usr/sbin' }
include openlldp
openlldp::config::lldp { 'eth0':
  adminstatus => 'rxtx',
  bridgescope => 'nb',
}
