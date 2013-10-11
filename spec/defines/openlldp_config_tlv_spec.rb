#!/usr/bin/env rspec

require 'spec_helper'

describe 'openlldp::config::tlv', :type => 'define' do
  let(:pre_condition) { 'class {"openlldp":}' }
  let :facts do {
    :osfamily        => 'RedHat',
    :operatingsystem => 'CentOS'
  }
  end
  let(:title) { 'myETHERNET' }

  tlvlist = ['portDesc', 'sysName', 'sysDesc', 'sysCap', 'mngAddr']

  context 'portDesc=foo' do
    let(:params) {{ :portDesc => 'foo' }}

    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /$portDesc must be yes or no./)
      }
    end
  end

  context 'bridgescope=foo' do
    let(:params) {{ :bridgescope => 'foo' }}

    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /$bridgescope parameter must be nearest_bridge, nb, nearest_customer_bridge, ncb, nearest_nontpmr_bridge, or nntpmrb./)
      }
    end
  end

  context 'default parameters' do
    tlvlist.each do |tlv|
      it { should contain_exec("set-tlv myETHERNET #{tlv}").with(
        :path    => ['/bin', '/usr/sbin'],
        :command => "lldptool set-tlv -i myETHERNET -g nb -V #{tlv} -c enableTx=no",
        :onlyif  => "lldptool get-tlv -i myETHERNET -g nb -V #{tlv} -c enableTx | grep -qv enableTx=no"
      )}
    end
  end

  tlvlist.each do |tlv|
    context "#{tlv}=yes" do
      let(:params) {{ tlv.to_sym => 'yes' }}

      it { should contain_exec("set-tlv myETHERNET #{tlv}").with(
        :path    => ['/bin', '/usr/sbin'],
        :command => "lldptool set-tlv -i myETHERNET -g nb -V #{tlv} -c enableTx=yes",
        :onlyif  => "lldptool get-tlv -i myETHERNET -g nb -V #{tlv} -c enableTx | grep -qv enableTx=yes"
      )}
    end
  end

  context 'portDesc=yes and bridgescope=nearest_nontpmr_bridge' do
    let :params do {
      :portDesc    => 'yes',
      :bridgescope => 'nearest_nontpmr_bridge'
    }
    end

    it { should contain_exec('set-tlv myETHERNET portDesc').with(
      :path    => ['/bin', '/usr/sbin'],
      :command => 'lldptool set-tlv -i myETHERNET -g nntpmrb -V portDesc -c enableTx=yes',
      :onlyif  => 'lldptool get-tlv -i myETHERNET -g nntpmrb -V portDesc -c enableTx | grep -qv enableTx=yes'
    )}
  end

end
