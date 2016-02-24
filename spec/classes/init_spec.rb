require 'spec_helper'

describe 'ispconfig' do

  let(:params) {
    { 'db_options'  => {
        'root_password'      => 'testrootpassword',
        'master_username'    => 'testmasterusername',
        'master_password'    => 'testmasterpassword',
        'master_hostname'    => 'testmasterhostname',
        'ispconfig_username' => 'testispconfigusername',
        'ispconfig_password' => 'testispconfigpassword',
        'ispconfig_database' => 'testispconfigdatabase',
      },
      'ssl_options' => {
        'ssl_cert_country'           => 'US',
        'ssl_cert_state'             => 'New York',
        'ssl_cert_locality'          => 'New York',
        'ssl_cert_organisation'      => 'Example',
        'ssl_cert_organisation_unit' => 'Unit',
      }
    }
  }

  let(:facts) {
    { :operatingsystem => 'Ubuntu',
      :osfamily        => 'Debian',
    }
  }

  context 'with defaults' do
    it { should contain_class('ispconfig') }
  end

  describe 'install database' do
    it { should contain_package('mysql-server') }
  end

  describe 'install php' do
    it { should contain_package('php5-cli') }
  end

  describe 'create autoinstall file' do
    it { is_expected.to contain_file('/root/ispconfig3_install/install/autoinstall.ini') }
  end

end
