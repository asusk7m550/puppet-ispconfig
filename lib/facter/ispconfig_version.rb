# ispconfig_version.rb

Facter.add('ispconfig_version') do
  setcode do
    Facter::Util::Resolution.exec('/usr/bin/mysql dbispconfig -ANe "select value from sys_config where name=\'db_version\'"')
  end
end
