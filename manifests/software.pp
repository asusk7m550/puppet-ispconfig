# == Class: ispconfig::software
#
# Install the software for ispconfig
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
#  include ispconfig::software
#
# === Authors
#
# Jasper Aikema <tech@ja-hosting.eu>
#
# === Copyright
#
# Copyright 2016 Jasper Aikema - JA
#
class ispconfig::software {

  case $::operatingsystem {
    /(Ubuntu)/ : {
      $dns_packages              = [ 'bind9', 'dnsutils' ]
      $mail_packages             = [ 'postfix', 'postfix-mysql', 'postfix-doc', 'openssl', 'getmail4', 'rkhunter', 'binutils', 'dovecot-imapd', 'dovecot-pop3d' ]
      $web_packages              = [ 'apache2-mpm-prefork', 'apache2-doc', 'apache2-utils', 'php5-curl', 'php5-gd', 'php5-imap', 'phpmyadmin', 'php-pear', 'php-auth', 'php5-imagick', 'apache2-suexec', 'sudo', 'zip', 'wget', 'pure-ftpd-common', 'pure-ftpd-mysql', 'quota', 'quotatool' ]
      $master_packages           = [ ]
      $basic_packages            = [ 'ntp', 'ntpdate', 'vim-common', 'mysql-common', 'php5-cli', 'php5-mysql','php5-mcrypt', 'mcrypt' ]
      $purge_packages            = [ 'apparmor', 'apparmor-utils', 'sendmail' ]
    }

    default: {
      fail("The ${module_name} module is not supported on ${::operatingsystem}.")
    }
  }

  package { [ $basic_packages ]:
    ensure => 'installed',
  }

  if $ispconfig::dns {
    package { [ $dns_packages ]:
      ensure => 'installed',
    }
  }

  if $ispconfig::mail {
    package { [ $mail_packages ]:
      ensure => 'installed',
    }
  }

  if $ispconfig::web {
    package { [ $web_packages ]:
      ensure => 'installed',
    }

    # Apache webserver
    class {'apache':
      default_mods      => false,
      default_vhost     => false,
      default_ssl_vhost => false,
      purge_vhost_dir   => false,
      trace_enable      => 'off',
      mpm_module        => 'prefork',
    }

    class {'apache::mod::actions': }
    class {'apache::mod::alias': }
    class {'apache::mod::include': }
    class {'apache::mod::dav_fs': }
    class {'apache::mod::dav': }
    class {'apache::mod::fcgid': }
    class {'apache::mod::suphp': }
    class {'apache::mod::perl': }
    class {'apache::mod::php': }
    class {'apache::mod::rewrite': }
    class {'apache::mod::autoindex': }
    class {'apache::mod::ssl':
      ssl_cipher => 'HIGH:MEDIUM:!aNULL:!MD5',
    }

    apache::mod { 'suexec': }

    apache::listen{'80': }
    apache::listen{'443': }

    file_line { 'pure-ftpd-enable-virtualchroot' :
      path  => '/etc/default/pure-ftpd-common',
      line  => 'VIRTUALCHROOT=true',
      match => '^VIRTUALCHROOT=.*$',
    }

  }

  if $ispconfig::master {
    package { [ $master_packages ]:
      ensure => 'installed',
    }
  }

  package { [ $purge_packages ]:
    ensure => 'purged',
  }

  file { '/bin/sh':
      ensure => 'link',
      target => '/bin/bash',
  }

  $override_options = {
    'mysqld' => {
      'bind-address' => '0.0.0.0',
    }
  }

  class { '::mysql::server':
    root_password           => $ispconfig::db_options['root_password'],
    remove_default_accounts => true,
    override_options        => $override_options,
    restart                 => true,
  }

}
