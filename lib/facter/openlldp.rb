#!/usr/bin/ruby
require 'facter'
# debug flag, for now not concerned about failed fact retrieval
debug=false

# http://www.ruby-forum.com/topic/3418285#1040695
module Enumerable
  def grep_v(cond)
    select {|x| not cond === x}
  end
end

if File.exists?('/usr/sbin/lldptool')
  lldp = {
    'chassisID' => '1',
    'portID'    => '2',
    'sysName'   => '5',
    'mngAddr'   => '8',
    'VLAN'      => '0x0080c201',
    'MTU'       => '0x00120f04',
  }

  Facter.value('interfaces').split(/,/).grep_v(/^lo$|^dummy[0-9]|^bond[0-9]/).each do |interface|
    puts "* interface is #{interface}" if debug
    lldp.each_pair do |key, value|
      puts "** #{key} is #{value}" if debug
      Facter.add("lldp_neighbor_#{key}_#{interface}") do
        setcode do
          output = Facter::Util::Resolution.exec("lldptool get-tlv -n -i #{interface} -V #{value} 2>/dev/null")
          #output = Facter::Util::Resolution.exec("MJAlldptool get-tlv -n -i #{interface} -V #{value} 2>/dev/null")
          if not output.nil?
            case key
            when 'sysName', 'MTU'
              puts "*** case #{key} : #{output}" if debug
              result = output.to_s.split("\n").last.strip
              puts "**** lldp_neighbor_#{key}_#{interface} #{result}!" if debug
            when 'chassisID'
              puts "*** case #{key} : #{output}" if debug
              output.split("\n").each do |line|
                if line.match(/MAC:\s+(.*)/) then
                  result = $1
                  puts "**** lldp_neighbor_#{key}_#{interface} #{result}!" if debug
                end
              end
            when 'portID'
              puts "*** case #{key} : #{output}" if debug
              output.split("\n").each do |line|
                if line.match(/Ifname:\s+(.*)/) then
                  result = $1
                  puts "**** lldp_neighbor_#{key}_#{interface} #{result}!" if debug
                end
              end
            when 'mngAddr'
              puts "*** case #{key} : #{output}" if debug
              output.split("\n").each do |line|
                if line.match(/IPv4:\s+(.*)/) then
                  result = $1
                  puts "**** lldp_neighbor_#{key}_#{interface} #{result}!" if debug
                end
              end
            when 'VLAN'
              puts "*** case #{key} : #{output}" if debug
              output.split("\n").each do |line|
                if line.match(/Info:\s+(.*)/) then
                  result = $1.to_i
                  puts "**** lldp_neighbor_#{key}_#{interface} #{result}!" if debug
                end
              end
            else
              nil
            end
            result
          end
        end
      end
    end
  end
end
