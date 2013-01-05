require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'

# https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/spec/spec_helper.rb
RSpec.configure do |config|
  # FIXME REVISIT - We may want to delegate to Facter like we do in
  # Puppet::PuppetSpecInitializer.initialize_via_testhelper(config) because
  # this behavior is a duplication of the spec_helper in Facter.
  config.before :each do
    # Ensure that we don't accidentally cache facts and environment between
    # test cases. This requires each example group to explicitly load the
    # facts being exercised with something like
    # Facter.collection.loader.load(:ipaddress)
    Facter::Util::Loader.any_instance.stubs(:load_all)
    Facter.clear
    Facter.clear_messages
  end
end
