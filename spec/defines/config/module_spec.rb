# frozen_string_literal: true

require 'spec_helper'

describe 'wildfly::config::module' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'org.postgresql' }
      let(:pre_condition) { 'include wildfly' }

      context 'with default template' do
        let(:params) do
          { :source => 'http://maven.repo.local/postgresql-9.3-1103-jdbc4.jar',
            :dependencies => ['javax.api', 'javax.transaction.api'] }
        end

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

      context 'with custom file' do
        let(:params) do
          { :source => 'http://maven.repo.local/postgresql-9.3-1103-jdbc4.jar',
            :dependencies => ['javax.api', 'javax.transaction.api'],
            :custom_file => 'wildfly/launch.sh' }
        end

        it do
          is_expected.to contain_file('/opt/wildfly/modules/system/layers/base/org/postgresql/main/module.xml')
            .with(:ensure => 'file',
                  :owner => 'wildfly',
                  :group => 'wildfly')
            .that_requires('File[/opt/wildfly/modules/system/layers/base/org/postgresql/main]')
        end
      end
    end
  end
end
