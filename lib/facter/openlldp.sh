#!/bin/bash
# http://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-bash-variable
trim() {
  local var="$@"
  var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
  var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
  echo -n "$var"
}

if [ -x /usr/sbin/lldptool ]; then
  for INTERFACE in $(facter interfaces | sed -e 's|,| |g'); do
    # Remove interfaces that pollute the list (like dummy0, bond0, and lo).
    if [ "$INTERFACE" = lo ]; then
      :
    elif [ -z "$INTERFACE" ]; then
      :
    elif echo "$INTERFACE" | grep -q ^dummy[0-9]; then
      :
    elif echo "$INTERFACE" | grep -q ^bond[0-9]; then
      :
#    elif echo "$INTERFACE" | grep -q ^vmnet[0-9]; then
#      :
    else
      # Loop through the list of LLDP TLVs that we want to present
      # as facts.
      for TLVNAME in chassisID portID sysName mngAddr VLAN MTU; do
        case $TLVNAME in
          chassisID)
            chassisID=$(lldptool get-tlv -n -i $INTERFACE -V 1 2>/dev/null | awk '/MAC:/{print $2}')
            chassisID=$(trim "$chassisID")
            if [ -n "$chassisID" ]; then
              echo "lldp_neighbor_chassisID_${INTERFACE} => ${chassisID}"
            fi
            ;;
          portID)
            portID=$(lldptool get-tlv -n -i $INTERFACE -V 2 2>/dev/null | awk -F: '/Ifname:/{print $2}')
            portID=$(trim "$portID")
            if [ -n "$portID" ]; then
              echo "lldp_neighbor_portID_${INTERFACE} => ${portID}"
            fi
            ;;
          sysName)
            sysName=$(lldptool get-tlv -n -i $INTERFACE -V 5 2>/dev/null | tail -1)
            sysName=$(trim "$sysName")
            if [ -n "$sysName" ]; then
              echo "lldp_neighbor_sysName_${INTERFACE} => ${sysName}"
            fi
            ;;
          mngAddr)
            mngAddr=$(lldptool get-tlv -n -i $INTERFACE -V 8 -c ipv4 2>/dev/null | awk -F: '/IPv4:/{print $2}')
            mngAddr=$(trim "$mngAddr")
            if [ -n "$mngAddr" ]; then
              echo "lldp_neighbor_mngAddr_ipv4_${INTERFACE} => ${mngAddr}"
            fi
            mngAddr=$(lldptool get-tlv -n -i $INTERFACE -V 8 -c ipv6 2>/dev/null | awk '/IPv6:/{print $NF}')
            mngAddr=$(trim "$mngAddr")
            if [ -n "$mngAddr" ]; then
              echo "lldp_neighbor_mngAddr_ipv6_${INTERFACE} => ${mngAddr}"
            fi
            ;;
          VLAN)
            VLAN=$(lldptool get-tlv -n -i $INTERFACE -V 0x0080c201 2>/dev/null | awk -F: '/Info:/{print $4}')
            VLAN=$(trim "$VLAN")
            VLAN=$(echo "$VLAN" | sed -e 's/^0*//')
            if [ -n "$VLAN" ]; then
              echo "lldp_neighbor_VLAN_${INTERFACE} => ${VLAN}"
            fi
            ;;
          MTU)
            MTU=$(lldptool get-tlv -n -i $INTERFACE -V 0x00120f04 2>/dev/null | tail -1)
            MTU=$(trim "$MTU")
            if [ -n "$MTU" ]; then
              echo "lldp_neighbor_MTU_${INTERFACE} => ${MTU}"
            fi
            ;;
        esac
      done
    fi
  done
fi
