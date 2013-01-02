#!/usr/bin/env rspec

require 'spec_helper'

describe 'openlldp facts' do
  before :each do
    Facter.fact(:interfaces).stubs(:value).returns('em2,lo')
    # Explicitly load the openlldp.rb file which contains generated facts
    # that cannot be automatically loaded. Puppet 2.x implements
    # Facter.collection.load while Facter 1.x markes Facter.collection.load as
    # a private method.
    if Facter.collection.respond_to? :load
      Facter.collection.load(:openlldp)
    else
      Facter.collection.loader.load(:openlldp)
    end
  end

  context 'if lldptool is not installed' do
    it 'facts should not run' do
      Facter::Util::Resolution.stubs(:which).with('lldptool').returns(nil)
      # I have no idea what I am doing here. How do I test for code that does not run?
      proc { Facter.value(:lldp_neighbor_chassisid_em2) }.should_not raise_error
      Facter.value(:lldp_neighbor_chassisid_em2).should be_nil
    end
  end

  context 'if lldptool is installed' do
    before :each do
      Facter::Util::Resolution.stubs(:which).with('lldptool').returns('/usr/sbin/lldptool')
    end

    context 'with no ethernet interfaces' do
      before :each do
        Facter.fact(:interfaces).stubs(:value).returns('lo')
      end

      it 'no lldp_neighbor_* facts should be available' do
        # I have no idea what I am doing here. How do I test for code that does not run?
        proc { Facter.value(:lldp_neighbor_portid_em2) }.should_not raise_error
        Facter.value(:lldp_neighbor_portid_em2).should be_nil
      end
    end

    context 'with no LLDP neighbor' do
      it 'lldp_neighbor_chassisid_em2 is nil' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 1 2>/dev/null').returns(nil)
        Facter.value(:lldp_neighbor_chassisid_em2).should be_nil
      end
      it 'lldp_neighbor_portid_em2 is nil' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 2 2>/dev/null').returns(nil)
        Facter.value(:lldp_neighbor_portid_em2).should be_nil
      end
      it 'lldp_neighbor_sysname_em2 is nil' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 5 2>/dev/null').returns(nil)
        Facter.value(:lldp_neighbor_sysname_em2).should be_nil
      end
      it 'lldp_neighbor_mngaddr_ipv4_em2 is nil' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 8 2>/dev/null').returns(nil)
        Facter.value(:lldp_neighbor_mngaddr_ipv4_em2).should be_nil
      end
      it 'lldp_neighbor_mngaddr_ipv6_em2 is nil' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 8 2>/dev/null').returns(nil)
        Facter.value(:lldp_neighbor_mngaddr_ipv6_em2).should be_nil
      end
      it 'lldp_neighbor_pvid_em2 is nil' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 0x0080c201 2>/dev/null').returns(nil)
        Facter.value(:lldp_neighbor_pvid_em2).should be_nil
      end
      it 'lldp_neighbor_mtu_em2 is nil' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 0x00120f04 2>/dev/null').returns(nil)
        Facter.value(:lldp_neighbor_mtu_em2).should be_nil
      end
    end

    context 'with LLDP neighbor' do
      it 'lldp_neighbor_chassisid_em2 is 00:21:86:9f:89:17' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 1 2>/dev/null').returns(my_fixture_read('chassisID'))
        Facter.value(:lldp_neighbor_chassisid_em2).should == '00:21:86:9f:89:17'
      end
      it 'lldp_neighbor_portid_em2 is Ethernet40' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 2 2>/dev/null').returns(my_fixture_read('portID'))
        Facter.value(:lldp_neighbor_portid_em2).should == 'Ethernet40'
      end
      it 'lldp_neighbor_sysname_em2 is motivation.localdomain' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 5 2>/dev/null').returns(my_fixture_read('sysName'))
        Facter.value(:lldp_neighbor_sysname_em2).should == 'motivation.localdomain'
      end
      it 'lldp_neighbor_mngaddr_ipv4_em2 is 192.168.2.57' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 8 2>/dev/null').returns(my_fixture_read('mngAddr'))
        Facter.value(:lldp_neighbor_mngaddr_ipv4_em2).should == '192.168.2.57'
      end
      it 'lldp_neighbor_mngaddr_ipv6_em2 is ::192.168.2.57' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 8 2>/dev/null').returns(my_fixture_read('mngAddr'))
        Facter.value(:lldp_neighbor_mngaddr_ipv6_em2).should == '::192.168.2.57'
      end
      it 'lldp_neighbor_pvid_em2 is 1' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 0x0080c201 2>/dev/null').returns(my_fixture_read('PVID'))
        Facter.value(:lldp_neighbor_pvid_em2).should == 1
      end
      it 'lldp_neighbor_mtu_em2 is 9236' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 0x00120f04 2>/dev/null').returns(my_fixture_read('MTU'))
        Facter.value(:lldp_neighbor_mtu_em2).should == '9236'
      end
    end
  end

end
