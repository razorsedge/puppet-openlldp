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
  $ensure = $::openlldp_ensure ? {
    undef   => 'present',
    default => $::openlldp_ensure,
  }

  $package_name = $::openlldp_package_name ? {
    undef   => 'lldpad',
    default => $::openlldp_package_name,
  }

  $service_ensure = $::openlldp_service_ensure ? {
    undef   => 'running',
    default => $::openlldp_service_ensure,
  }

  $service_name = $::openlldp_service_name ? {
    undef   => 'lldpad',
    default => $::openlldp_service_name,
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.
  $autoupgrade = $::openlldp_autoupgrade ? {
    undef   => false,
    default => $::openlldp_autoupgrade,
  }
  if is_string($autoupgrade) {
    $safe_autoupgrade = str2bool($autoupgrade)
  } else {
    $safe_autoupgrade = $autoupgrade
  }

  $service_enable = $::openlldp_service_enable ? {
    undef   => true,
    default => $::openlldp_service_enable,
  }
  if is_string($service_enable) {
    $safe_service_enable = str2bool($service_enable)
  } else {
    $safe_service_enable = $service_enable
  }

  $service_hasrestart = $::openlldp_service_hasrestart ? {
    undef   => true,
    default => $::openlldp_service_hasrestart,
  }
  if is_string($service_hasrestart) {
    $safe_service_hasrestart = str2bool($service_hasrestart)
  } else {
    $safe_service_hasrestart = $service_hasrestart
  }

  $service_hasstatus = $::openlldp_service_hasstatus ? {
    undef   => true,
    default => $::openlldp_service_hasstatus,
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
