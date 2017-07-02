#!/usr/bin/env rspec

require 'spec_helper'

describe 'openlldp::config::lldp', :type => 'define' do
  let(:pre_condition) { 'class {"openlldp":}' }
  let :facts do {
    :osfamily        => 'RedHat',
    :operatingsystem => 'CentOS'
  }
  end
  let(:title) { 'myETHERNET' }

  context 'adminStatus=foo' do
    let(:params) {{ :adminstatus => 'foo' }}

    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /$adminstatus must be disabled, rx, tx, or rxtx./)
      }
    end
  end

  context 'adminStatus=disabled' do
    let(:params) {{ :adminstatus => 'disabled' }}

    it { should contain_exec('set-lldp myETHERNET').with(
      :path    => ['/bin', '/usr/sbin'],
      :command => 'lldptool set-lldp -i myETHERNET -g nb adminStatus=disabled',
      :onlyif  => 'lldptool get-lldp -i myETHERNET -g nb adminStatus | grep -qv adminStatus=disabled$'
    )}
  end

  context 'adminStatus=rx' do
    let(:params) {{ :adminstatus => 'rx' }}

    it { should contain_exec('set-lldp myETHERNET').with(
      :path    => ['/bin', '/usr/sbin'],
      :command => 'lldptool set-lldp -i myETHERNET -g nb adminStatus=rx',
      :onlyif  => 'lldptool get-lldp -i myETHERNET -g nb adminStatus | grep -qv adminStatus=rx$'
    )}
  end

  context 'adminStatus=tx' do
    let(:params) {{ :adminstatus => 'tx' }}

    it { should contain_exec('set-lldp myETHERNET').with(
      :path    => ['/bin', '/usr/sbin'],
      :command => 'lldptool set-lldp -i myETHERNET -g nb adminStatus=tx',
      :onlyif  => 'lldptool get-lldp -i myETHERNET -g nb adminStatus | grep -qv adminStatus=tx$'
    )}
  end

  context 'adminStatus=rxtx' do
    let(:params) {{ :adminstatus => 'rxtx' }}

    it { should contain_exec('set-lldp myETHERNET').with(
      :path    => ['/bin', '/usr/sbin'],
      :command => 'lldptool set-lldp -i myETHERNET -g nb adminStatus=rxtx',
      :onlyif  => 'lldptool get-lldp -i myETHERNET -g nb adminStatus | grep -qv adminStatus=rxtx$'
    )}
  end

  context 'adminStatus=disabled and bridgescope=foo' do
    let :params do {
      :adminstatus => 'disabled',
      :bridgescope => 'foo'
    }
    end

    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /$bridgescope parameter must be nearest_bridge, nb, nearest_customer_bridge, ncb, nearest_nontpmr_bridge, or nntpmrb./)
      }
    end
  end

  context 'adminStatus=rxtx and bridgescope=nearest_customer_bridge' do
    let :params do {
      :adminstatus => 'rxtx',
      :bridgescope => 'nearest_customer_bridge'
    }
    end

    it { should contain_exec('set-lldp myETHERNET').with(
      :path    => ['/bin', '/usr/sbin'],
      :command => 'lldptool set-lldp -i myETHERNET -g ncb adminStatus=rxtx',
      :onlyif  => 'lldptool get-lldp -i myETHERNET -g ncb adminStatus | grep -qv adminStatus=rxtx$'
    )}
  end

  context 'adminStatus=rxtx and bridgescope=nearest_nontpmr_bridge' do
    let :params do {
      :adminstatus => 'rxtx',
      :bridgescope => 'nearest_nontpmr_bridge'
    }
    end

    it { should contain_exec('set-lldp myETHERNET').with(
      :path    => ['/bin', '/usr/sbin'],
      :command => 'lldptool set-lldp -i myETHERNET -g nntpmrb adminStatus=rxtx',
      :onlyif  => 'lldptool get-lldp -i myETHERNET -g nntpmrb adminStatus | grep -qv adminStatus=rxtx$'
    )}
  end

end
