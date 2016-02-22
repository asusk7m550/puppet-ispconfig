# == Class: ispconfig
#
# A class for installing ISPConfig. Based on https://www.howtoforge.com/perfect-server-ubuntu-14.04-apache2-php-mysql-pureftpd-bind-dovecot-ispconfig-3
#
# === Parameters
#
# Module Specific parameters
#
# [*ssl_options]
#   An array of options for the SSL configuration of ISPConfig
#
# [*db_options*]
#   An array of options for the database configuration inside ISPConfig
#
# [*mail*]
#   Specify whether the mail role should be installed
#
# [*web*]
#   Specify whether the web role should be installed
#
# [*dns*]
#   Specify whether the dns role should be installed
#
# [*file*]
#   Specify whether the file role should be installed
#
# [*database*]
#   Specify whether the database role should be installed
#
# [*master*]
#   Is this server its own master or is there another master
#
# === Variables
#
# There are no variables used
#
# === Examples
#
#  $db_options = {
#    root_password      => '<password for the root user>',
#    master_username    => '<the username which will be used to connect to the master>',
#    master_password    => '<the password which will be used to connect to the master>',
#    master_hostname    => '<the hostname on which the master database runs>',
#    ispconfig_username => '<the username which will be used for ispconfig>',
#    ispconfig_password => '<the password which will be used for ispconfig>',
#    ispconfig_database => '<the database which will be used for ispconfig>',
#  }
#
#  $ssl_options = {
#    ssl_cert_country           => '<the two-letter ISO code for the country where your organization is located>',
#    ssl_cert_state             => '<the state/region where your organization is located>',
#    ssl_cert_locality          => '<the city where your organization is located>',
#    ssl_cert_organisation      => '<the legal name of your organization>',
#    ssl_cert_organisation_unit => '<the division of your organization handling the certificate>',
#  }
#
#  class {'ispconfig':
#    mail        => true,
#    web         => true,
#    dns         => true,
#    file        => true,
#    database    => true,
#    master      => true,
#    ssl_options => $ssl_options,
#    db_options  => $db_options,
#  }
#
# === Authors
#
# Jasper Aikema <tech@ja-hosting.eu>
#
# === Copyright
#
# Copyright 2016 Jasper Aikema - JA
#
class ispconfig (
  $ssl_options = undef,
  $db_options  = undef,
  $mail        = false,
  $web         = false,
  $dns         = false,
  $file        = false,
  $database    = false,
  $master      = false,
) {

  # Install the requiremented software
  include ispconfig::software

  # Install the software
  include ispconfig::install

  # Setup the master when defined as master
  if $master {
    include ispconfig::master
  }
}
