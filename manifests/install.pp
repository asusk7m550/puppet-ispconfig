# == Class: ispconfig::install
#
# Installs ispconfig
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
#  include ispconfig::install
#
# === Authors
#
# Jasper Aikema <tech@ja-hosting.eu>
#
# === Copyright
#
# Copyright 2016 Jasper Aikema - JA
#
class ispconfig::install {

  # Get some variables
  $mail        = $ispconfig::mail
  $web         = $ispconfig::web
  $dns         = $ispconfig::dns
  $file        = $ispconfig::file
  $database    = $ispconfig::database
  $master      = $ispconfig::master

  # Create an autoinstall file
  file { '/root/ispconfig3_install/install/autoinstall.ini' :
    ensure    => 'present',
    owner     => 'root',
    group     => 'root',
    mode      => '0600',
    content   => template('ispconfig/autoinstall.ini.erb'),
    subscribe => Exec['extract_ispconfig'],
  }

  file { '/root/ISPConfig-3-stable.tar.gz' :
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///modules/ispconfig/ISPConfig-3.0.5.4p8-patched.tar.gz',
  }

  exec { 'extract_ispconfig' :
    command     => '/bin/rm -rf /root/ispconfig3_install && /bin/tar -xzf /root/ISPConfig-3-stable.tar.gz',
    cwd         => '/root',
    subscribe   => File['/root/ISPConfig-3-stable.tar.gz'],
    refreshonly => true,
  }

  exec { 'install_ispconfig' :
    command => '/usr/bin/php install.php --autoinstall=autoinstall.ini > /root/ispconfig.log',
    cwd     => '/root/ispconfig3_install/install',
    require => [ Exec['extract_ispconfig'], Mysql::Db["${ispconfig::db_options['master_username']}@${::fqdn}/${ispconfig::db_options['ispconfig_database']}"] ],
    onlyif  => "/usr/bin/mysql -u ${ispconfig::db_options['master_username']} -p${ispconfig::db_options['master_password']} -h ${ispconfig::ispconfig_master} -e ''",
    unless  => '/usr/bin/test -d /usr/local/ispconfig',
  }

  unless $ispconfig::master {
    mysql::db { "${ispconfig::db_options['master_username']}@${::fqdn}/${ispconfig::db_options['ispconfig_database']}":
      user     => $ispconfig::db_options['master_username'],
      password => $ispconfig::db_options['master_password'],
      dbname   => $ispconfig::db_options['ispconfig_database'],
      host     => $::fqdn,
      grant    => ['ALL'],
      tag      => 'ispconfig',
    }

    @@mysql::user { "${ispconfig::db_options['master_username']}@${::fqdn}/*":
      user          => $ispconfig::db_options['master_username'],
      password      => $ispconfig::db_options['master_password'],
      dbname        => '*',
      host          => $::fqdn,
      charset       => 'latin1',
      collate       => 'latin1_swedish_ci',
      grant         => ['ALL'],
      grant_options => ['GRANT'],
      tag           => 'ispconfig',
    }

  }

}
