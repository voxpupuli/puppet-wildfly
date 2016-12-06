require 'spec_helper'

describe 'wildfly::config::module' do
  let(:facts) do
    { :operatingsystem => 'CentOS',
      :kernel => 'Linux',
      :osfamily => 'RedHat',
      :operatingsystemmajrelease => '7',
      :initsystem => 'systemd' }
  end

  let(:title) { 'org.postgresql' }

  let(:params) do
    { :source => 'http://maven.repo.local/postgresql-9.3-1103-jdbc4.jar',
      :dependencies => ['javax.api', 'javax.transaction.api'] }
  end

  let(:pre_condition) { 'include wildfly' }

  it do
    is_expected.to contain_exec('Create Parent Directories: org.postgresql')
      .with(:command => 'mkdir -p /opt/wildfly/modules/system/layers/base/org/postgresql/main',
            :user => 'wildfly')
      .that_requires('Class[wildfly::install]')
      .that_comes_before('File[/opt/wildfly/modules/system/layers/base/org/postgresql/main]')
  end

  it do
    is_expected.to contain_file('/opt/wildfly/modules/system/layers/base/org/postgresql/main')
      .with(:ensure => 'directory',
            :owner => 'wildfly',
            :group => 'wildfly')
  end

  it do
    is_expected.to contain_file('/opt/wildfly/modules/system/layers/base/org/postgresql/main/postgresql-9.3-1103-jdbc4.jar')
      .with(:ensure => 'file',
            :owner => 'wildfly',
            :group => 'wildfly')
      .that_requires('File[/opt/wildfly/modules/system/layers/base/org/postgresql/main]')
  end

  it do
    is_expected.to contain_file('/opt/wildfly/modules/system/layers/base/org/postgresql/main/module.xml')
      .with(:ensure => 'file',
            :owner => 'wildfly',
            :group => 'wildfly')
      .that_requires('File[/opt/wildfly/modules/system/layers/base/org/postgresql/main]')
  end
end
