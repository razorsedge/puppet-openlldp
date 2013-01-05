#!/usr/bin/env rspec

require 'spec_helper'

describe 'openlldp facts' do
  context 'if lldptool is not installed' do
    before :each do
      File.stubs(:exists?).with('/usr/sbin/lldptool').returns(false)
      #Facter::Util::Resolution.stubs(:which).with('lldptool').returns(nil)
      Facter.fact(:interfaces).stubs(:value).returns('eth2,lo')
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

    it 'facts should not run' do
      Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i eth2 -V 1 2>/dev/null').returns(my_fixture_read('chassisID'))
      # I have no idea what I am doing here. How do I test for code that does not run?
      proc { Facter.value(:lldp_neighbor_chassisid_eth2) }.should_not raise_error
      Facter.value(:lldp_neighbor_chassisid_eth2).should be_nil
    end
  end


  context 'if lldptool is installed' do
    context 'with no ethernet interfaces' do
      before :each do
        File.stubs(:exists?).with('/usr/sbin/lldptool').returns(true)
        #Facter::Util::Resolution.stubs(:which).with('lldptool').returns('/usr/sbin/lldptool')
        Facter.fact(:interfaces).stubs(:value).returns('lo')
        if Facter.collection.respond_to? :load
          Facter.collection.load(:openlldp)
        else
          Facter.collection.loader.load(:openlldp)
        end
      end

      it 'no lldp_neighbor_* facts should be available' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 1 2>/dev/null').returns(my_fixture_read('chassisID'))
        # I have no idea what I am doing here. How do I test for code that does not run?
        proc { Facter.value(:lldp_neighbor_chassisid_em2) }.should_not raise_error
        Facter.value(:lldp_neighbor_chassisid_em2).should be_nil
        proc { Facter.value(:lldp_neighbor_portid_lo) }.should_not raise_error
        Facter.value(:lldp_neighbor_portid_lo).should be_nil
      end
    end

    context 'with incorrect/inactive ethernet interface' do
      before :each do
        File.stubs(:exists?).with('/usr/sbin/lldptool').returns(true)
        #Facter::Util::Resolution.stubs(:which).with('lldptool').returns('/usr/sbin/lldptool')
        Facter.fact(:interfaces).stubs(:value).returns('em2,lo')
        if Facter.collection.respond_to? :load
          Facter.collection.load(:openlldp)
        else
          Facter.collection.loader.load(:openlldp)
        end
      end

      it 'lldp_neighbor_chassisid_em2 is nil' do
        Facter::Util::Resolution.stubs(:exec).with('lldptool get-tlv -n -i em2 -V 1 2>/dev/null').returns(my_fixture_read('device_not_found'))
        Facter.value(:lldp_neighbor_chassisid_em2).should be_nil
      end
    end

    context 'with no LLDP neighbor' do
      before :each do
        File.stubs(:exists?).with('/usr/sbin/lldptool').returns(true)
        #Facter::Util::Resolution.stubs(:which).with('lldptool').returns('/usr/sbin/lldptool')
        Facter.fact(:interfaces).stubs(:value).returns('em2,lo')
        if Facter.collection.respond_to? :load
          Facter.collection.load(:openlldp)
        else
          Facter.collection.loader.load(:openlldp)
        end
      end

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
      before :each do
        File.stubs(:exists?).with('/usr/sbin/lldptool').returns(true)
        #Facter::Util::Resolution.stubs(:which).with('lldptool').returns('/usr/sbin/lldptool')
        Facter.fact(:interfaces).stubs(:value).returns('em2,lo')
        if Facter.collection.respond_to? :load
          Facter.collection.load(:openlldp)
        else
          Facter.collection.loader.load(:openlldp)
        end
      end

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
