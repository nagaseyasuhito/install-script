# update packages
yum update -y

# user add
while [ -z $user_name ]
do
	echo -n "enter user name(ex. nagase): "
	read user_name
done

echo -n "enter group name(default: users): "
read group_name

if [ -z $group_name ]
then
	group_name="users"
fi

useradd -g "$group_name" -G wheel  "$user_name"
if [ $? != 0 ]
then
	exit 1
fi

passwd $user_name
if [ $? != 0 ]
then
	exit 2
fi

# register ssh public key
mkdir /home/$user_name/.ssh
chown $user_name:$group_name /home/$user_name/.ssh
chmod 700 /home/$user_name/.ssh

while [ -z $ssh_public_key ]
do
	echo -n "enter ssh public key: "
	read ssh_public_key
done
echo $ssh_public_key > /home/$user_name/.ssh/authorized_keys
chown $user_name:$group_name /home/$user_name/.ssh/authorized_keys
chmod 600 /home/$user_name/.ssh/authorized_keys

# setup su/sudo settings
#echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

# setup ssh settings
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
sed -i "s/^PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
service sshd restart
