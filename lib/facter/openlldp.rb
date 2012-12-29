# Fact:
#   lldp_neighbor_chassisid_<interface>
#   lldp_neighbor_mngaddr_<interface>
#   lldp_neighbor_mtu_<interface>
#   lldp_neighbor_portid_<interface>
#   lldp_neighbor_sysname_<interface>
#   lldp_neighbor_vlan_<interface>
#
# Purpose:
#   Return information about the host's LLDP neighbors.
#
# Resolution:
#   On hosts with the /usr/sbin/lldptool binary, send queries to the lldpad
#   for each of the host's Ethernet interfaces and parse the output.
#
# Caveats:
#   Assumes that the connected Ethernet switch is sending LLDPDUs, Open-LLDP
#   (lldpad) is running, and lldpad is configured to receive LLDPDUs on each
#   Ethernet interface.
#

# http://www.ruby-forum.com/topic/3418285#1040695
module Enumerable
  def grep_v(cond)
    select {|x| not cond === x}
  end
end

if File.exists?('/usr/sbin/lldptool')
  lldp = {
    # LLDP Name    Numeric value
    'chassisID' => '1',
    'portID'    => '2',
    'sysName'   => '5',
    'mngAddr'   => '8',
    'VLAN'      => '0x0080c201',
    'MTU'       => '0x00120f04',
  }

  Facter.value('interfaces').split(/,/).grep_v(/^lo$|^dummy[0-9]|^bond[0-9]/).each do |interface|
    lldp.each_pair do |key, value|
      Facter.add("lldp_neighbor_#{key}_#{interface}") do
        setcode do
          result = ""
          output = Facter::Util::Resolution.exec("lldptool get-tlv -n -i #{interface} -V #{value} 2>/dev/null")
          if not output.nil?
            case key
            when 'sysName', 'MTU'
              output.split("\n").each do |line|
                if line.match(/^\s+(.*)/) then
                  result = $1
                end
              end
            when 'chassisID'
              output.split("\n").each do |line|
                if line.match(/MAC:\s+(.*)/) then
                  result = $1
                end
              end
            when 'portID'
              output.split("\n").each do |line|
                if line.match(/Ifname:\s+(.*)/) then
                  result = $1
                end
              end
            when 'mngAddr'
              output.split("\n").each do |line|
                if line.match(/IPv4:\s+(.*)/) then
                  result = $1
                end
              end
            when 'VLAN'
              output.split("\n").each do |line|
                if line.match(/Info:\s+(.*)/) then
                  result = $1.to_i
                end
              end
            else
              # case default
              result = nil
            end
          else
            # No output from lldptool
            result = nil
          end
          result
        end
      end
    end
  end
end
