#!/bin/bash

# sysinfo_page - A script to produce an system information HTML file

##### Constants


TITLE="Tanium Status for $HOSTNAME"
RIGHT_NOW="$(date +"%x %r %Z")"
TIME_STAMP="Updated on $RIGHT_NOW by $USER"

##### Functions

system_info()
{
      echo "<h2>Tanium Status</h2>"
    if  systemctl status taniumclient
    then
         echo systemctl status taniumclient
    else
        echo "Tanium appears not be running please the following command"
        echo "For - Amazon Linux / Debian / SUSE / OpenSUSE / Red Hat / CentOS (v5 & v6) / Ubuntu (ver 14, 10)"
        echo "service TaniumClient start"
        echo "service TaniumClient stop"

        echo "For - Oracle Enterprise Linux  /Red Hat /CentOS (v7) / Ubuntu (ver 16)"
        echo "systemctl start taniumclient"
        echo "systemctl stop taniumclient"

        echo "Note: If the Tanium Client is not present, please reinstall Tanium"
    fi

    
}


show_uptime()
{
    echo "<h2>System uptime</h2>"
    echo "<pre>"
    uptime
    echo "</pre>"
}


tanium_config()
{
   echo "<h2>Tanium Config File</h2>"
   echo "<pre>"

   if  cd /opt/Tanium/TaniumClient
   then
    ./TaniumClient config list
   exit
   else
    echo "Tanium Client is Not Intalled"
    echo " 1. Copy the Tanium Client settings below."
    echo "./TaniumClient config set ServerNameList tanium-srv-prod-z1.accenture.com,tanium-srv-prod-z2.accenture.com"
    echo "/TaniumClient config set LogVerbosityLevel 1"
    echo "./TaniumClient config set ServerPort 443 "
    echo "/TaniumClient config set ListenPort 17472"
    echo "./TaniumClient config set Resolver nslookup"
    echo "./TaniumClient config set ServerName tanium-srv-prod-z1.accenture.com"

    echo "2. Restart the Tanium Client  Service"

    echo "Note: Only if after all previous steps still not reporting. please change the LogVerbosityLevel value."
    echo "Set LogVerbosityLevel value from 1 to 41"
    echo "bounce the service wait a few minutes and  return the value to 1"
  fi

}

tanium_nslookup()
{
  echo "<h2>Tanium nslookup</h2>"
  echo "<pre>"
  nslookup tanium-srv-prod-a.accenture.com
  nslookup tanium-srv-prod-b.accenture.com
  echo "<pre>"
  nslookup tanium-srv-prod-z1.accenture.com
  nslookup tanium-srv-stage.z2.accenture.com

}


tanium_ports()
{
   echo "<h2>Accenture Network</h2>"
   echo "<p>Stage a port 443</p>"
   timeout 5 telnet tanium-srv-prod-a.accenture.com 443
   echo "<p>Stage b port 443</p>"
   timeout 5 telnet tanium-srv-prod-b.accenture.com 443


   echo "<p>Stage a port 80</p>"
   timeout 5 telnet tanium-srv-prod-a.accenture.com 80
   echo "<p>Stage  b port 80</p>"
   timeout 5 telnet tanium-srv-prod-b.accenture.com 80


  echo  "<h2>Accenture Non Network</h2>"

  echo "<p>Stage z1 port 433</p>"
  timeout 5 telnet tanium-srv-prod-z1.accenture.com 443
  echo "<p>Stage z2 port 433</p>"
  timeout 5 telnet tanium-srv-prod-z2.accenture.com 443


  echo "<p>Stage z1 port 80</p>"
  timeout 5 telnet tanium-srv-prod-z1.accenture.com 80
  echo "<p>Stage z2 port 80</p>"
  timeout 5 telnet tanium-srv-prod-z2.accenture.com 80

}


tanium_hostFiles()
{

 echo "<h2>Tanium Host Files</h2>"

 cd /etc/ 
 a=$(cat < hosts)
 echo $a
 
}



##### Main

cat <<- _EOF_
  <html>
  <head>
      <title>$TITLE</title>
  </head>

  <body>
      <h1>$TITLE</h1>
      <p>$TIME_STAMP</p>
      $(system_info)
      $(show_uptime)
      $(tanium_config)
      $(tanium_nslookup)
      $(tanium_ports)
      $(tanium_hostFiles)
      
  </body>
  </html>
_EOF_

