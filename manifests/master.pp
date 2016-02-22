# == Class: ispconfig::master
#
# Class to setup the ISPConfig master. This class will create a database for
# ISPConfig and collects the DB users from all the slave servers.
#
# === Parameters
#
# There are no parameters
#
# === Variables
#
# There are no variables used
#
# === Examples
#
#  include ispconfig::master
#
# === Authors
#
# Jasper Aikema <tech@ja-hosting.eu>
#
# === Copyright
#
# Copyright 2016 Jasper Aikema - JA
#
class ispconfig::master {

  # Create a main database and user for ISPConfig
  mysql::db { "${ispconfig::db_options['master_username']}@${::fqdn}/${ispconfig::db_options['ispconfig_database']}":
    user     => $ispconfig::db_options['master_username'],
    password => $ispconfig::db_options['master_password'],
    dbname   => $ispconfig::db_options['ispconfig_database'],
    host     => $::fqdn,
    grant    => ['SELECT', 'UPDATE'],
    notify   => Exec['install_ispconfig'],
  }

  # Collect all the DB users from the slave servers and create them on the
  # master server
  if $::ispconfig_installed == true {
    Mysql::User <<| tag == 'ispconfig' |>>
  }

}
