# ispconfig

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What ispconfig affects](#what-ispconfig-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ispconfig](#beginning-with-ispconfig)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install the hosting control panel ISPconfig. You can use one single server with
all the components or install one master and distribute the components between
a bunch of other servers.

## Module Description

Somehow based on the installation manual made by ISPconfig (which can be found on
https://www.howtoforge.com/perfect-server-ubuntu-14.04-apache2-php-mysql-pureftpd-bind-dovecot-ispconfig-3).

It installs the components which are needed to give the customers what the want.
The components which will be installed are webhosting (Apache and PHP), database
(MySQL), DNS (Bind) and email (Postfix / Dovecot).

The modules does install all the required components, after that ir installs and 
configures ISPconfig.

## Setup

### What ispconfig affects

* For webhosting it will use the puppetlabs-apache module and installs Apache2 with PHP
* For the database it will use the puppetlabs-mysql module and installs MySQL
* As mailserver it will install postfix and dovecot and removes sendmail
* As dnsserver it will install bind9

### Setup Requirements

To use the module, make sure you have the following modules in your module directory:
* puppetlabs-apache
* puppetlabs-mysql

### Beginning with ispconfig

Use the following syntax to include the class for a all-in-one node installation,
the easiest way to get the variables is using hiera or some other ENC.

```puppet
  $db_options = {
    root_password      => '<password for the root user>',
    master_username    => '<the username which will be used to connect to the master>',
    master_password    => '<the password which will be used to connect to the master>',
    master_hostname    => '<the hostname on which the master database runs>',
    ispconfig_username => '<the username which will be used for ispconfig>',
    ispconfig_password => '<the password which will be used for ispconfig>',
    ispconfig_database => '<the database which will be used for ispconfig>',
  }

  $ssl_options = {
    ssl_cert_country           => '<the two-letter ISO code for the country where your organization is located>',
    ssl_cert_state             => '<the state/region where your organization is located>',
    ssl_cert_locality          => '<the city where your organization is located>',
    ssl_cert_organisation      => '<the legal name of your organization>',
    ssl_cert_organisation_unit => '<the division of your organization handling the certificate>',
  }

  class {'ispconfig':
    mail        => true,
    web         => true,
    dns         => true,
    file        => true,
    database    => true,
    master      => true,
    ssl_options => $ssl_options,
    db_options  => $db_options,
  }
```

## Usage

An easy all-in-one installation can be used with the syntax before. When you want
to use the module for a multi server installation, with all the components on
seperate servers, you can use the following syntax
```puppet
node 'master.node' {

  $db_options = {
    root_password      => '<password for the root user>',
    master_username    => '<the username which will be used to connect to the master>',
    master_password    => '<the password which will be used to connect to the master>',
    master_hostname    => '<the hostname on which the master database runs>',
    ispconfig_username => '<the username which will be used for ispconfig>',
    ispconfig_password => '<the password which will be used for ispconfig>',
    ispconfig_database => '<the database which will be used for ispconfig>',
  }

  $ssl_options = {
    ssl_cert_country           => '<the two-letter ISO code for the country where your organization is located>',
    ssl_cert_state             => '<the state/region where your organization is located>',
    ssl_cert_locality          => '<the city where your organization is located>',
    ssl_cert_organisation      => '<the legal name of your organization>',
    ssl_cert_organisation_unit => '<the division of your organization handling the certificate>',
  }

  class {'ispconfig':
    web         => true,
    master      => true,
    ssl_options => $ssl_options,
    db_options  => $db_options,
  }
}

node 'ns01.node' {

  $db_options = {
    root_password      => '<password for the root user>',
    master_username    => '<the username which will be used to connect to the master>',
    master_password    => '<the password which will be used to connect to the master>',
    master_hostname    => '<the hostname on which the master database runs>',
    ispconfig_username => '<the username which will be used for ispconfig>',
    ispconfig_password => '<the password which will be used for ispconfig>',
    ispconfig_database => '<the database which will be used for ispconfig>',
  }

  $ssl_options = {
    ssl_cert_country           => '<the two-letter ISO code for the country where your organization is located>',
    ssl_cert_state             => '<the state/region where your organization is located>',
    ssl_cert_locality          => '<the city where your organization is located>',
    ssl_cert_organisation      => '<the legal name of your organization>',
    ssl_cert_organisation_unit => '<the division of your organization handling the certificate>',
  }

  class {'ispconfig':
    dns         => true,
    ssl_options => $ssl_options,
    db_options  => $db_options,
  }
}

node 'db01.node' {

  $db_options = {
    root_password      => '<password for the root user>',
    master_username    => '<the username which will be used to connect to the master>',
    master_password    => '<the password which will be used to connect to the master>',
    master_hostname    => '<the hostname on which the master database runs>',
    ispconfig_username => '<the username which will be used for ispconfig>',
    ispconfig_password => '<the password which will be used for ispconfig>',
    ispconfig_database => '<the database which will be used for ispconfig>',
  }

  $ssl_options = {
    ssl_cert_country           => '<the two-letter ISO code for the country where your organization is located>',
    ssl_cert_state             => '<the state/region where your organization is located>',
    ssl_cert_locality          => '<the city where your organization is located>',
    ssl_cert_organisation      => '<the legal name of your organization>',
    ssl_cert_organisation_unit => '<the division of your organization handling the certificate>',
  }

  class {'ispconfig':
    database    => true,
    ssl_options => $ssl_options,
    db_options  => $db_options,
  }
}

node 'mx01.node' {

  $db_options = {
    root_password      => '<password for the root user>',
    master_username    => '<the username which will be used to connect to the master>',
    master_password    => '<the password which will be used to connect to the master>',
    master_hostname    => '<the hostname on which the master database runs>',
    ispconfig_username => '<the username which will be used for ispconfig>',
    ispconfig_password => '<the password which will be used for ispconfig>',
    ispconfig_database => '<the database which will be used for ispconfig>',
  }

  $ssl_options = {
    ssl_cert_country           => '<the two-letter ISO code for the country where your organization is located>',
    ssl_cert_state             => '<the state/region where your organization is located>',
    ssl_cert_locality          => '<the city where your organization is located>',
    ssl_cert_organisation      => '<the legal name of your organization>',
    ssl_cert_organisation_unit => '<the division of your organization handling the certificate>',
  }

  class {'ispconfig':
    mail        => true,
    ssl_options => $ssl_options,
    db_options  => $db_options,
  }
}

node 'web01.node' {

  $db_options = {
    root_password      => '<password for the root user>',
    master_username    => '<the username which will be used to connect to the master>',
    master_password    => '<the password which will be used to connect to the master>',
    master_hostname    => '<the hostname on which the master database runs>',
    ispconfig_username => '<the username which will be used for ispconfig>',
    ispconfig_password => '<the password which will be used for ispconfig>',
    ispconfig_database => '<the database which will be used for ispconfig>',
  }

  $ssl_options = {
    ssl_cert_country           => '<the two-letter ISO code for the country where your organization is located>',
    ssl_cert_state             => '<the state/region where your organization is located>',
    ssl_cert_locality          => '<the city where your organization is located>',
    ssl_cert_organisation      => '<the legal name of your organization>',
    ssl_cert_organisation_unit => '<the division of your organization handling the certificate>',
  }

  class {'ispconfig':
    web         => true,
    ssl_options => $ssl_options,
    db_options  => $db_options,
  }
}
```

## Reference

### Classes

#### Public classes

* [`ispconfig`](#ispconfig): Installs and configures ISPconfig.
* [`ispconfig::master`](#ispconfigmaster): Installs the ISPconfig master.

#### Private classes

* `ispconfig::software`: Installs the needed software packages for ISPconfig.
* `ispconfig::install`: Gets the ISPconfig software and installs it.

### Parameters

#### ispconfig

#####  `ssl_options`
   An array of options for the SSL configuration of ISPConfig

#####  `db_options`
   An array of options for the database configuration inside ISPConfig

#####  `mail`
   Specify whether the mail role should be installed

#####  `web`
   Specify whether the web role should be installed

#####  `dns`
   Specify whether the dns role should be installed

#####  `file`
   Specify whether the file role should be installed

#####  `database`
   Specify whether the database role should be installed

#####  `master`
   Is this server its own master or is there another master

## Limitations

The software is beta and should not be used in production yet. It is only tested on
Ubuntu 14.04 with a master and all the components on seperate servers.

## Development

Easy it with care and share all the good things that come from it.
