openlldp Module
===============

master branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-openlldp.png?branch=master)](http://travis-ci.org/razorsedge/puppet-openlldp)
develop branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-openlldp.png?branch=develop)](http://travis-ci.org/razorsedge/puppet-openlldp)

Introduction
------------

This module installs [Open-LLDP](http://www.open-lldp.org/).  lldpad (LLDP Agent Daemon) is a GPL licensed implementation of the Link Layer Discovery Protocol for Linux.

Actions:

* Installs Open-LLDP (lldpad).
* Starts lldpad.

OS Support:

* RedHat family - tested on CentOS 5.5+ and CentOS 6.2+
* SuSE family   - presently unsupported (patches welcome)
* Debian family - presently unsupported (patches welcome)

Class documentation is available via puppetdoc.

Examples
--------

    include 'openlldp'


Notes
-----

* None

Issues
------

* None

TODO
----

* Provide LLDP facts via facter.
* Configure lldpad to receive and/or transmit LLDP frames via  the included lldptool.

License
-------

Please see LICENSE file.

Copyright
---------

Copyright (C) 2012 Mike Arnold <mike@razorsedge.org>

[razorsedge/puppet-openlldp on GitHub](https://github.com/razorsedge/puppet-openlldp)

[razorsedge/openlldp on Puppet Forge](http://forge.puppetlabs.com/razorsedge/openlldp)

