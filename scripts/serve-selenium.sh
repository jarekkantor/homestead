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
wget http://selenium-release.storage.googleapis.com/2.50/selenium-server-standalone-2.50.1.jar -nv -O /home/vagrant/selenium-server-standalone-2.50.1.jar

# Create bash script which will start in background X Virtual FrameBuffer and Selenium Standalone Server
code="sudo Xvfb :10 -ac &
export DISPLAY=:10
java -jar /home/vagrant/selenium-server-standalone-2.50.1.jar &
"

echo "$code" > "/home/vagrant/init-testing"
chown vagrant:vagrant /home/vagrant/init-testing
chmod +x /home/vagrant/init-testing
/home/vagrant/init-testing

# Add script to cron so it runs on start up 
(crontab -u vagrant -l 2>/dev/null; echo "@reboot ~/init-testing") | crontab -u vagrant -

# Cloning Xdebug
echo "Cloning Xdebug source code"
git clone git://github.com/xdebug/xdebug.git

# Compiling Xdebug
echo "Compiling Xdebug"
cd xdebug
phpize
./configure --enable-xdebug
make
cp modules/xdebug.so /usr/lib/php/20151012
echo 'zend_extension = /usr/lib/php/20151012/xdebug.so' >> /etc/php/7.0/fpm/php.ini

# Restarting PHP FPM
service php7.0-fpm restart
rm -r xdebug
