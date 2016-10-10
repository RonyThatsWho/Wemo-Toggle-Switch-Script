#!/bin/sh
#
# WeMo Toggle Switch Script
#
# Usage: ./wemo IP_ADDRESS
#
#
IP=$1

if [ "$1" = "" ]
   then
      echo "Usage: ./wemo_control IP_ADDRESS"
else

    PORT=0
    
    for PTEST in 49153 49152 49153 49154 49155
    do
            PORTTEST=$(curl -s -m 3 $IP:$PTEST | grep "404")
                      
            if [ "$PORTTEST" != "" ]
               then
               PORT=$PTEST
               break
            fi
    done
    
    if [ $PORT = 0 ]
             then
       echo "Cannot find a port"
       exit
    fi
    
     echo "Port = "$PORT
     STATUS=$(curl -0 -A '' -X POST -H 'Accept: ' -H 'Content-type: text/xml; charset="utf-8"' -H "SOAPACTION: \"urn:Belkin:service:basicevent:1#GetBinaryState\"" --data '<?xml version="1.0" encoding="utf-8"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:GetBinaryState xmlns:u="urn:Belkin:service:basicevent:1"><BinaryState>1</BinaryState></u:GetBinaryState></s:Body></s:Envelope>' -s http://$IP:$PORT/upnp/control/basicevent1 | 
grep "<BinaryState"  | cut -d">" -f2 | cut -d "<" -f1 | sed 's/0/OFF/g' | sed 's/1/ON/g' )
  
     if [ "$STATUS" = "OFF" ]
  
        then
  
           curl -0 -A '' -X POST -H 'Accept: ' -H 'Content-type: text/xml; charset="utf-8"' -H "SOAPACTION: \"urn:Belkin:service:basicevent:1#SetBinaryState\"" --data '<?xml version="1.0" encoding="utf-8"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:SetBinaryState xmlns:u="urn:Belkin:service:basicevent:1"><BinaryState>1</BinaryState></u:SetBinaryState></s:Body></s:Envelope>' -s http://$IP:$PORT/upnp/control/basicevent1 |
  grep "<BinaryState"  | cut -d">" -f2 | cut -d "<" -f1
  
     elif [ "$STATUS" = "ON" ]
  
        then
  
           curl -0 -A '' -X POST -H 'Accept: ' -H 'Content-type: text/xml; charset="utf-8"' -H "SOAPACTION: \"urn:Belkin:service:basicevent:1#SetBinaryState\"" --data '<?xml version="1.0" encoding="utf-8"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:SetBinaryState xmlns:u="urn:Belkin:service:basicevent:1"><BinaryState>0</BinaryState></u:SetBinaryState></s:Body></s:Envelope>' -s http://$IP:$PORT/upnp/control/basicevent1 |
  grep "<BinaryState"  | cut -d">" -f2 | cut -d "<" -f1

     else
  
        echo "COMMAND NOT RECOGNIZED"
        echo ""
        echo "Usage: ./wemo IP_ADDRESS"
        echo ""
  
     fi
fi