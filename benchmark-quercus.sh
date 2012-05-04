QUERCUS=quercus-4.0.25

sudo yum update -y
sudo yum install -y php php-pear php-pecl-apc tomcat7
sudo pear channel-discover pear.ethna.jp
sudo pear install -a ethna/ethna-beta

sudo chgrp -R apache /var/www
sudo chmod -R g+w /var/www
cd /var/www/html
sudo sudo -u apache ethna add-project sandbox
cd /usr/share/tomcat7/webapps
sudo sudo -u tomcat wget http://caucho.com/download/$QUERCUS.war
sudo service tomcat7 start
while [ ! -e $QUERCUS ] ;
do
	sleep 1
done
sudo sudo -u tomcat cp -Rp /var/www/html/sandbox ./$QUERCUS
 
sudo service httpd start
