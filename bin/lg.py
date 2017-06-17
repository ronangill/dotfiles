#!/usr/bin/env python3
 
# TODO
# Use keep-alive connection


#Full list of commands
#http://developer.lgappstv.com/TV_HELP/index.jsp?topic=%2Flge.tvsdk.references.book%2Fhtml%2FUDAP%2FUDAP%2FAnnex+A+Table+of+virtual+key+codes+on+remote+Controller.htm
import http.client
from tkinter import *
import xml.etree.ElementTree as etree
import socket
import re
import sys
import time
 
lgtv = {}
dialogMsg =""
headers = {"Content-Type": "application/atom+xml"}
lgtv["ipaddress"] ="192.168.1.60"
lgtv["pairingKey"] = "380905" # replace when known
 
def getip():
    strngtoXmit =   'M-SEARCH * HTTP/1.1' + '\r\n' + \
                    'HOST: 239.255.255.250:1900'  + '\r\n' + \
                    'MAN: "ssdp:discover"'  + '\r\n' + \
                    'MX: 2'  + '\r\n' + \
                    'ST: urn:schemas-upnp-org:device:MediaRenderer:1'  + '\r\n' +  '\r\n'
 
    bytestoXmit = strngtoXmit.encode()
    sock = socket.socket( socket.AF_INET, socket.SOCK_DGRAM )
    sock.settimeout(3)
    found = False
    gotstr = 'notyet'
    i = 0
    ipaddress = None
    sock.sendto( bytestoXmit,  ('239.255.255.250', 1900 ) )
    while not found and i <= 5 and gotstr == 'notyet':
        try:
            gotbytes, addressport = sock.recvfrom(512)
            gotstr = gotbytes.decode()
        except:
            i += 1
            sock.sendto( bytestoXmit, ( '239.255.255.250', 1900 ) )
        if re.search('LG', gotstr):
            ipaddress, _ = addressport
            found = True
        else:
            gotstr = 'notyet'
        i += 1
    sock.close()
    if not found : sys.exit("Lg TV not found")
    return ipaddress
 
def displayKey():
    conn = http.client.HTTPConnection( lgtv["ipaddress"], port=8080)
    reqKey = "<?xml version=\"1.0\" encoding=\"utf-8\"?><auth><type>AuthKeyReq</type></auth>"
    conn.request("POST", "/roap/api/auth", reqKey, headers=headers)
    httpResponse = conn.getresponse()
    if httpResponse.reason != "OK" : sys.exit("Network error")
    return httpResponse.reason
 
def getSessionid():
    conn = http.client.HTTPConnection( lgtv["ipaddress"], port=8080)
    pairCmd = "<?xml version=\"1.0\" encoding=\"utf-8\"?><auth><type>AuthReq</type><value>" \
            + lgtv["pairingKey"] + "</value></auth>"
    conn.request("POST", "/roap/api/auth", pairCmd, headers=headers)
    httpResponse = conn.getresponse()
    print (httpResponse)
    if httpResponse.reason != "OK" : return httpResponse.reason
    tree = etree.XML(httpResponse.read())
    return tree.find('session').text
 
def getPairingKey():
    displayKey()
 
def handleCommand(cmdcode):
    conn = http.client.HTTPConnection( lgtv["ipaddress"], port=8080)
    cmdText = "<?xml version=\"1.0\" encoding=\"utf-8\"?><command>" \
                + "<name>HandleKeyInput</name><value>" \
                + cmdcode \
                + "</value></command>"
    conn.request("POST", "/roap/api/command", cmdText, headers=headers)
    httpResponse = conn.getresponse()

def handleMouseMove(x, y):
    conn = http.client.HTTPConnection( lgtv["ipaddress"], port=8080)
    cmdText = "<?xml version=\"1.0\" encoding=\"utf-8\"?><command>" \
                + "<name>HandleTouchMove</name>" \
                + "<x>" + x + "</x>" \
                + "<y>" + y + "</y>" \
                + "</command>"
    conn.request("POST", "/roap/api/command", cmdText, headers=headers)
    httpResponse = conn.getresponse()

def handleClick():
    conn = http.client.HTTPConnection( lgtv["ipaddress"], port=8080)
    cmdText = "<?xml version=\"1.0\" encoding=\"utf-8\"?><command>" \
                + "<name>HandleTouchClick</name>" \
                + "</command>"
    conn.request("POST", "/roap/api/command", cmdText, headers=headers)
    httpResponse = conn.getresponse()
 
def usage():
    print (sys.argv[0]+': <tv-name> <pairingcode> C|M<mouseX,mouseY>|<key>....\n')
    sys.exit(2)

#main()

if len(sys.argv) < 3 : usage()

lgtv["ipaddress"] = socket.gethostbyname(str(sys.argv[1]))
lgtv["pairingKey"] = str(sys.argv[2])
 
#getip()
 
theSessionid = getSessionid()
while theSessionid == "Unauthorized" :
    getPairingKey()
    theSessionid = getSessionid()
 
if len(theSessionid) < 8 : sys.exit("Could not get Session Id: " + theSessionid)
 
lgtv["session"] = theSessionid
 
#Uncomment the line below the first time to invoke pairing menu
#displayKey()

for key in sys.argv[3:] :
    print("Sending ",key)
    if key[0] == "M":
        xy=key[1:].split(",")
        handleMouseMove(xy[0],xy[1])
    elif key[0] == "C": handleClick()
    else: handleCommand(key)
    time.sleep(.8)

"""
From http://developer.lgappstv.com/TV_HELP/index.jsp?topic=%2Flge.tvsdk.references.book%2Fhtml%2FUDAP%2FUDAP%2FAnnex+A+Table+of+virtual+key+codes+on+remote+Controller.htm
Annex A Table of virtual key codes on remote Controller

The table below shows virtual key codes of the remote Controller keys used by the HandleKeyInput command in Command. To send virtual key codes to the Host using HandleKeyInput, assign appropriate values for desired purposes by referring to the table below.
 
[Table]Virtual key codes on remote Controller

Virtual key code (decimal number) Description
1 POWER
2 Number 0
3 Number 1
4 Number 2
5 Number 3
6 Number 4
7 Number 5
8 Number 6
9 Number 7
10 Number 8
11 Number 9
12 UP key among remote Controllerâ€™s 4 direction keys
13 DOWN key among remote Controllerâ€™s 4 direction keys
14 LEFT key among remote Controllerâ€™s 4 direction keys
15 RIGHT key among remote Controllerâ€™s 4 direction keys
20 OK
21 Home menu
22 Menu key (same with Home menu key)
23 Previous key (Back)
24 Volume up
25 Volume down
26 Mute (toggle)
27 Channel UP (+)
28 Channel DOWN (-)
29 Blue key of data broadcast
30 Green key of data broadcast
31 Red key of data broadcast
32 Yellow key of data broadcast
33 Play
34 Pause
35 Stop
36 Fast forward (FF)
37 Rewind (REW)
38 Skip Forward
39 Skip Backward
40 Record
41 Recording list
42 Repeat
43 Live TV
44 EPG
45 Current program information
46 Aspect ratio
47 External input
48 PIP secondary video
49 Show / Change subtitle
50 Program list
51 Tele Text
52 Mark
400 3D Video
401 3D L/R
402 Dash (-)
403 Previous channel (Flash back)
404 Favorite channel
405 Quick menu
406 Text Option
407 Audio Description
408 NetCast key (same with Home menu)
409 Energy saving
410 A/V mode
411 SIMPLINK
412 Exit
413 Reservation programs list
414 PIP channel UP
415 PIP channel DOWN
416 Switching between primary/secondary video
417 My Apps
"""
