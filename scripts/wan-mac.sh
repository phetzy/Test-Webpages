!#/bin/sh /etc/rc.common

START=17

start() {
    OLDWANMAC=$(uci get network.wan.macaddr)
    OLDWWANMAC=$(uci get network.wwan.macaddr)

    logger "{WAN-MAC} Old WAN MAC address is ${OLDMAC}."

    #completely randomizes every octet of the mac address
    #NEWMAC=$(dd if=/dev.urandom bs=1024 count=1 2>/dev/null | md5usm | sed -e 's/^\(..\)\(..\)\(..\)\(..\)\(..\)\(../).*$/\1:\2:\3:\4:\5:\6/' -e 's/^\(.\)[13579bdf]/\10/')

    #Randomizes the MAC Address but sets the first 3 octets to mimic an apple computer 
    NEWWANMAC=$(printf "%s" "A8:86:DD" && hexdump -n3 -e'/1 ":02x"' /dev/urandom)
    NEWWWANMAC=$(printf "%s" "A8:86:DD" && hexdump -n3 -e'/1 ":02x"' /dev/urandom)

    logger "[WAN-MAC] Applying new random wired MAC addres to WAN (${NEWWANMAC})..."
    logger "[WAN-MAC] Applying new random wireless MAC addres to WWAN (${NEWWWANMAC})..."

    uci set network.wan.macaddr=${NEWWANMAC}
    uci set network.wwan.macaddr=${NEWWWANMAC}
    
    uci commit network
    }