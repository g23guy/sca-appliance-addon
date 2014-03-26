#!/bin/bash -e
#
# This script is executed at the end of appliance creation.  Here you can do
# one-time actions to modify your appliance before it is ever used, like
# removing files and directories to make it smaller, creating symlinks,
# generating indexes, etc.
#
# The 'kiwi_type' variable will contain the format of the appliance
# (oem = disk image, vmx = VMware, iso = CD/DVD, xen = Xen).
#
DPASS='linux'

# read in some variables
. /studio/profile

# read in KIWI utility functions
. /.kconfig

#======================================
# Creating Self-Signed HTTPS Keys
#--------------------------------------
openssl req -new -x509 -days 365 -keyout /etc/apache2/ssl.key/sca.key -out /etc/apache2/ssl.crt/sca.crt -nodes -subj  '/O=SCA Appliance/OU=Supportconfig Analysis Appliance/CN=localhost'

#======================================
# Configure default services
#--------------------------------------
# Services to turn on
for i in 'apache2.service' 'vsftpd.service' 'sshd.service' 'after-local.service'
do
    echo "* Enabling systemd Service: $i "
    systemctl enable $i
done
for i in mysql
do
    echo "* Enabling SysV Service: $i "
    chkconfig $i on
done

#======================================
# MySQL Configuration
#--------------------------------------
echo "* Starting MySQL "
/etc/init.d/mysql start
sleep 2
/usr/bin/mysqladmin -u root password $DPASS
echo "* MySQL Password Set "
sleep 1

#======================================
# SCA User Description
#--------------------------------------
sed -i -e 's!0:0:root:/!0:0:SCA Notification:/!g' /etc/passwd

