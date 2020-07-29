#!/bin/bash
# Minecraft Server Installation Script

if [ -L $0 ]
then
	source `readlink -e $0 | sed "s:[^/]*$:configsetupminecraft:"`
else
	source `echo $0 | sed "s:[^/]*$:configsetupminecraft:"`
fi

if [ "$initdir" == "" ]
then
	echo "Couldn't load configsetupminecraft file, please edit configsetupminecraft.example and rename it to configsetupminecraft"
	logger -t minecraft-init "Couldn't load configsetupminecraft file, please edit configsetupminecraft.example and rename it to configsetupminecraft"
	exit
fi

# Check to see if Minecraft directory already exists, if it does then exit
if [ -d $initdir ]; then
  echo "Directory $initdir already exists!  Updating scripts..."
  #sudo systemctl stop $SERVICENAME.service
  installed="true"

  # Get Home directory path and username
  cd $initdir

  # Remove existing scripts
  rm minecraft config

  #exit 0
else
  # Create server directory
  installed="false"
  echo "Creating minecraft server directory..."
  mkdir $installdir
  cd $installdir
  mkdir logs
  mkdir $initdir
  cd $initdir

  # Not ready yet!
  ## Download service from repository
  #echo "Grabbing service from repository..."
  #wget -O $SERVICENAME.service $httpfilelocation/$SERVICENAME.service

  ## Service configuration
  #echo "Configuring minecraft service..."
  #sed -i "s:dirname:$installdir:g" $SERVICENAME.service

fi

# Download minecraft from repository
echo "Grabbing minecraft from repository..."
wget -O minecraft $httpfilelocation/minecraft
chmod +x minecraft

# Download config from repository
echo "Grabbing config from repository..."
wget -O config $httpfilelocation/minecraft_config
sed -i "s:dirname:$installdir:g" config
sed -i "s:SERVICENAME:$SERVICENAME:g" config

# Check CPU archtecture to see if we need to do anything special for the platform the server is running on
echo "Getting system CPU architecture..."
CPUArch=$(uname -m)
echo "System Architecture: $CPUArch"

#$initdir/minecraft check-update

if [ $installed == "false" ] ; then
  # Not needed - keep for now.
  #unzip -o "downloads/$DownloadFile"
  #cd $installdir
  #$initdir/pyunzip.py "$initdir/downloads/$DownloadFile"

  # Server configuration
  #echo "Enter a name for your server..."
  #read -p 'Server Name: ' ServerName < /dev/tty
  #sed -i "s/server-name=Dedicated Server/server-name=$ServerName/g" server.properties

  echo "Do the following as admin user:"
  echo "ln -s $initdir/$SERVICENAME.service /etc/systemd/system/$SERVICENAME.service"
  
  echo "sudo systemctl daemon-reload"
  echo "To start Minecraft server at startup automatically:"

  echo "sudo systemctl enable $SERVICENAME.service"
  exit 0

fi

# Finished! # Setup completed
  echo "Setup is complete."  #Starting Minecraft server..."
  #sudo systemctl start $SERVICENAME.service
  #echo "Sleep for 4 seconds to give the server time to start"
  #sleep 4s
  #echo "Done - use screen -r minecraft_screen"
