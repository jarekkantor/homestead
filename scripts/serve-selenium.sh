#!/usr/bin/env bash

apt-get update

# Install Java
echo "Installing Java RE"
apt-get -y install default-jre

# Install X Virtual FrameBuffer
echo "Installing X Virtual FrameBuffer"
apt-get -y install xvfb

# Install Firefox
echo "Installing Firefox"
apt-get -y install firefox

# Download Selenium Standalone Server
echo "Downloading Selenium Standalone Server"
wget http://selenium-release.storage.googleapis.com/2.49/selenium-server-standalone-2.49.0.jar -nv -O /home/vagrant/selenium-server-standalone-2.49.0.jar

# Create bash script which will start in background X Virtual FrameBuffer and Selenium Standalone Server
code="sudo Xvfb :10 -ac &
export DISPLAY=:10
java -jar /home/vagrant/selenium-server-standalone-2.49.0.jar &
"

echo "$code" > "/home/vagrant/init-testing"
chown vagrant:vagrant /home/vagrant/init-testing
chmod +x /home/vagrant/init-testing
/home/vagrant/init-testing

# Add script to cron so it runs on start up 
(crontab -u vagrant -l ; echo "@reboot /home/vagrant/init-testing") | crontab -u vagrant -
