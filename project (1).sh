#!/bin/bash

anonstat=$(sudo perl nipe.pl status | grep -i status | awk '{print $3}')
anonip=$(sudo perl nipe.pl status | grep -i Ip | awk '{print $3}')
anonctry=$(geoiplookup $anonip| grep -i country | awk '{print $NF}')

if [  $anonstat == true  ]
then
	echo "the spoofed ip is $anonip .  Spoofed country: $anonctry"
	echo 'You may now enter a Domain/IP address to be scanned:' 
	read victim
	echo $victim
	
	echo 'Enter the IP address of remote server:'
	read Ipadd
	echo 'Enter the username:'
	read username

	ut=$(sshpass -p kali ssh kali@192.168.188.128 'uptime')
	echo "Uptime: $ut"
	ip=$(sshpass -p kali ssh kali@192.168.188.128 'curl ifconfig.io')
	echo "IP Address: $ip"
	cy=$(geoiplookup $ip | awk '{print $NF}')
	echo "Country: $cy"
	
	echo 'Whois-ing victim now:'
	sshpass -p kali ssh kali@192.168.188.128 "whois $victim" > whois_"$victim"
	echo $(date -u) - whois data collected for: "$victim" >> NR_log

	echo 'Nmap-ing victim now:'
	sshpass -p kali ssh kali@192.168.188.128 "nmap $victim -p- -Pn" > nmap_"$victim" 
	echo $(date -u) - Nmap data collected for: "$victim" >> NR_log


else

	echo 'Your network is not anonymous!'
	exit

fi

