# == Class: openlldp
#
# This class handles installing Open-LLDP.
# http://www.open-lldp.org/
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*autoupgrade*]
#   Upgrade package automatically, if there is a newer version.
#   Default: false
#
# [*package_name*]
#   Name of the package.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*service_ensure*]
#   Ensure if service is running or stopped.
#   Default: running
#
# [*service_name*]
#   Name of the service
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*service_enable*]
#   Start service at boot.
#   Default: false
#
# [*service_hasrestart*]
#   Service has restart command.
#   Default: true
#
# [*service_hasstatus*]
#   Service has status command.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: true
#
# === Actions:
#
# Installs the openlldp package.
# Starts the openlldp service.
#
# === Sample Usage:
#
#  class { 'openlldp': }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class openlldp (
  $ensure              = $openlldp::params::ensure,
  $autoupgrade         = $openlldp::params::safe_autoupgrade,
  $package_name        = $openlldp::params::package_name,
  $service_ensure      = $openlldp::params::service_ensure,
  $service_name        = $openlldp::params::service_name,
  $service_enable      = $openlldp::params::safe_service_enable,
  $service_hasrestart  = $openlldp::params::safe_service_hasrestart,
  $service_hasstatus   = $openlldp::params::service_hasstatus
) inherits openlldp::params {
  # Validate our booleans
  validate_bool($autoupgrade)
  validate_bool($service_enable)
  validate_bool($service_hasrestart)
  validate_bool($service_hasstatus)

  case $ensure {
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }

      if $service_ensure in [ running, stopped ] {
        $service_ensure_real = $service_ensure
        $service_enable_real = $service_enable
      } else {
        fail('service_ensure parameter must be running or stopped')
      }
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $service_ensure_real = 'stopped'
      $service_enable_real = false
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  package { $package_name :
    ensure  => $package_ensure,
  }

  service { $service_name :
    ensure     => $service_ensure_real,
    enable     => $service_enable_real,
    hasrestart => $service_hasrestart,
    hasstatus  => $service_hasstatus,
    require    => Package[$package_name],
  }
}
