# frozen_string_literal: true

require 'spec_helper'

describe 'wildfly::domain::server_group' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include wildfly' }

      let(:title) { 'sample-server-group' }

      context 'with ensure present' do
        context 'with required parameters' do
          let(:params) do
            {
              :profile => 'full-ha',
              :socket_binding_group => 'full-ha-sockets',
              :jvm_name => 'jvm',
            }
          end

          it do
            is_expected.to contain_wildfly__resource("/server-group=#{title}")
              .with(content: {
                'profile' => 'full-ha',
                'socket-binding-group' => 'full-ha-sockets',
                'socket-binding-port-offset' => 0,
              })
            # FIXME jvm depende desse aqui de cima

            is_expected.to contain_wildfly__resource("/server-group=#{title}/jvm=jvm")
              .with(content: {})
          end
        end

        context 'with profile missing' do
          let(:params) do
            { :socket_binding_group => 'full-ha-sockets' }
          end

          it { is_expected.to compile.and_raise_error(/profile is required/) }
        end

        context 'with socket_binding_group missing' do
          let(:params) do
            { :profile => 'full-ha' }
          end

          it { is_expected.to compile.and_raise_error(/socket_binding_group is required/) }
        end
      end

      context 'with ensure absent' do
        let(:params) do
          { :ensure => 'absent' }
        end

        it { is_expected.to contain_wildfly__resource("/server-group=#{title}").with(ensure: 'absent') }
      end
    end
  end
end
