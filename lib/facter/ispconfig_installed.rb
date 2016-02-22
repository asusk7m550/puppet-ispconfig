# ispconfig_installed.rb

Facter.add('ispconfig_installed') do
  setcode do
    if File.directory? '/usr/local/ispconfig'
      true
    else
      false
    end
  end
end
