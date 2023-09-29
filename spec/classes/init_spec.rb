# frozen_string_literal: true

require 'spec_helper'

describe 'wildfly' do
  context 'with defaults for all parameters' do
    let(:facts) do
      { :operatingsystem => 'CentOS',
        :kernel => 'Linux',
        :osfamily => 'RedHat',
        :operatingsystemmajrelease => '7',
        :initsystem => 'systemd' }
    end

    it { is_expected.to contain_class('wildfly') }
    it { is_expected.to contain_class('wildfly::prepare').that_comes_before('Class[wildfly::install]') }
    it { is_expected.to contain_class('wildfly::install').that_comes_before('Class[wildfly::setup]') }
    it { is_expected.to contain_class('wildfly::setup').that_comes_before('Class[wildfly::service]') }
    it { is_expected.to contain_class('wildfly::service') }
  end

  context 'with overlay_class' do
    let(:facts) do
      { :operatingsystem => 'CentOS',
        :kernel => 'Linux',
        :osfamily => 'RedHat',
        :operatingsystemmajrelease => '7',
        :initsystem => 'systemd' }
    end

    let(:pre_condition) { "class profile::jboss::overlay { notify { 'hello :D': } }" }

    let(:params) { { overlay_class: 'profile::jboss::overlay' } }

    it { is_expected.to contain_class('profile::jboss::overlay').that_requires('Class[wildfly::install]') }
    it { is_expected.to contain_class('profile::jboss::overlay').that_comes_before('Class[wildfly::setup]') }
  end
end
