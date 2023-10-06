# frozen_string_literal: true

require 'spec_helper'

describe 'wildfly::config::app_user' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include wildfly' }
      let(:title) { 'wildfly' }
      let(:params) do
        { :password => 'safepass' }
      end

      it do
        is_expected.to contain_wildfly__config__user('wildfly:ApplicationRealm')
          .with(:password => 'safepass',
                :file_name => 'application-users.properties')
      end
    end
  end
end
