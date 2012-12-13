#!/usr/bin/env rspec

require 'spec_helper'

describe 'openlldp', :type => 'class' do

  context 'on a non-supported operatingsystem' do
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'bar'
    }
    end
    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /Unsupported platform: foo/)
      }
    end
  end

  context 'on a supported operatingsystem, default parameters' do
    let(:params) {{}}
    let :facts do {
      :osfamily        => 'RedHat',
      :operatingsystem => 'CentOS'
    }
    end
    it { should contain_package('lldpad').with_ensure('present') }
    it { should contain_service('lldpad').with(
      :ensure     => 'running',
      :enable     => true,
      :hasrestart => true,
      :hasstatus  => true
    )}
  end

  context 'on a supported operatingsystem, custom parameters' do
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6'
    }
    end

    describe 'ensure => absent' do
      let :params do {
        :ensure => 'absent'
      }
      end
      it { should contain_package('lldpad').with_ensure('absent') }
      it { should contain_service('lldpad').with(
        :ensure => 'stopped',
        :enable => false
      )}
    end

    describe 'autoupgrade => true' do
      let :params do {
        :autoupgrade => true
      }
      end
      it { should contain_package('lldpad').with_ensure('latest') }
      it { should contain_service('lldpad').with(
        :ensure => 'running',
        :enable => true
      )}
    end

    describe 'package_name => not-lldpad' do
      let :params do {
        :package_name => 'not-lldpad'
      }
      end
      it { should contain_package('not-lldpad').with_ensure('present') }
      it { should contain_service('lldpad').with(
        :ensure => 'running',
        :enable => true
      )}
    end
  end

end
