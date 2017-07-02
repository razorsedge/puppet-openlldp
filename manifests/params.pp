# == Class: openlldp::params
#
# This class handles OS-specific configuration of the openlldp module.  It
# looks for variables in top scope (probably from an ENC such as Dashboard).  If
# the variable doesn't exist in top scope, it falls back to a hard coded default
# value.
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class openlldp::params {
### The following parameters should not need to be changed.

  # If we have a top scope variable defined, use it, otherwise fall back to a
  # hardcoded value.
  $openlldp_ensure = getvar('::openlldp_ensure')
  if $openlldp_ensure {
    $ensure = $::openlldp_ensure
  } else {
    $ensure = 'present'
  }

  $openlldp_package_name = getvar('::openlldp_package_name')
  if $openlldp_package_name {
    $package_name = $::openlldp_package_name
  } else {
    $package_name = 'lldpad'
  }

  $openlldp_service_ensure = getvar('::openlldp_service_ensure')
  if $openlldp_service_ensure {
    $service_ensure = $::openlldp_service_ensure
  } else {
    $service_ensure = 'running'
  }

  $openlldp_service_name = getvar('::openlldp_service_name')
  if $openlldp_service_name {
    $service_name = $::openlldp_service_name
  } else {
    $service_name = 'lldpad'
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.
  $openlldp_autoupgrade = getvar('::openlldp_autoupgrade')
  if $openlldp_autoupgrade {
    $autoupgrade = $::openlldp_autoupgrade
  } else {
    $autoupgrade = false
  }
  if is_string($autoupgrade) {
    $safe_autoupgrade = str2bool($autoupgrade)
  } else {
    $safe_autoupgrade = $autoupgrade
  }

  $openlldp_service_enable = getvar('::openlldp_service_enable')
  if $openlldp_service_enable {
    $service_enable = $::openlldp_service_enable
  } else {
    $service_enable = true
  }
  if is_string($service_enable) {
    $safe_service_enable = str2bool($service_enable)
  } else {
    $safe_service_enable = $service_enable
  }

  $openlldp_service_hasrestart = getvar('::openlldp_service_hasrestart')
  if $openlldp_service_hasrestart {
    $service_hasrestart = $::openlldp_service_hasrestart
  } else {
    $service_hasrestart = true
  }
  if is_string($service_hasrestart) {
    $safe_service_hasrestart = str2bool($service_hasrestart)
  } else {
    $safe_service_hasrestart = $service_hasrestart
  }

  $openlldp_service_hasstatus = getvar('::openlldp_service_hasstatus')
  if $openlldp_service_hasstatus {
    $service_hasstatus = $::openlldp_service_hasstatus
  } else {
    $service_hasstatus = true
  }
  if is_string($service_hasstatus) {
    $safe_service_hasstatus = str2bool($service_hasstatus)
  } else {
    $safe_service_hasstatus = $service_hasstatus
  }

  case $::osfamily {
    'RedHat': { }
    #'Debian': { }
    #'Suse': { }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
