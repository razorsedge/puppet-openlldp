Puppet Open-LLDP Module
=======================

master branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-openlldp.png?branch=master)](http://travis-ci.org/razorsedge/puppet-openlldp)
develop branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-openlldp.png?branch=develop)](http://travis-ci.org/razorsedge/puppet-openlldp)

Introduction
------------

This module installs [Open-LLDP](http://www.open-lldp.org/).  lldpad (LLDP Agent Daemon) is a GPL licensed implementation of the Link Layer Discovery Protocol for Linux.

Actions:

* Installs Open-LLDP (lldpad).
* Starts lldpad.
* Provides LLDP neighbor facts via facter (requires lldpad running and configured to at least receive LLDP frames on each Ethernet interface).
* Configures lldpad to receive and/or transmit LLDP frames via the included lldptool.
* Configures lldpad to transmit LLDP TLVs.

OS Support:

* RedHat family - tested on CentOS 6.3
* SuSE family   - presently unsupported (patches welcome)
* Debian family - presently unsupported (patches welcome)

Class documentation is available via puppetdoc.

Examples
--------

```puppet
class { 'openlldp': }

# Configure lldpad to receive and transmit LLDP frames on the specific interface.
openlldp::config::lldp { 'eth0':
  adminstatus => 'rxtx',
}

# Configure lldpad to transmit Basic LLDP TLVs.
# openlldp::config::lldp adminstatus has to be tx or rxtx for these to transmit.
openlldp::config::tlv { 'eth0':
  portDesc => 'yes',
  sysName  => 'yes',
  sysDesc  => 'yes',
  sysCap   => 'yes',
  mngAddr  => 'yes',
}
```

Notes
-----

* Open-LLDP talks about applying configurations globally by not specifying "-i ethX" to lldptool. This has not worked with the versions tested (0.9.43), thus a global configuration mode has not been built into the Puppet module.
* PVID TLV is not suported as a keyword with the versions tested (0.9.43), thus the code uses numerical values for all TLVs.

Issues
------

* None

TODO
----

* None

Contributing
------------

Please see CONTRIBUTING.md for contribution information.

License
-------

Please see LICENSE file.

Copyright
---------

Copyright (C) 2012 Mike Arnold <mike@razorsedge.org>

[razorsedge/puppet-openlldp on GitHub](https://github.com/razorsedge/puppet-openlldp)

[razorsedge/openlldp on Puppet Forge](http://forge.puppetlabs.com/razorsedge/openlldp)

