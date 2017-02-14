require 'spec_helper'
require 'json'

describe Puppet::Type.type(:wildfly_resource).attrclass(:state) do
  let(:path) { '/subsystem=dummy' }

  let(:resource) { Puppet::Type.type(:wildfly_resource).new :title => path }

  describe 'when testing wether the state is in sync without recursive' do
    let(:state) { described_class.new(:resource => resource) }

    it 'is not in sync if hashes do not match' do
      state.should = { 'name' => 'dummy', 'value' => 'anotherResource' }

      is = { 'name' => 'dummy', 'value' => 'resource' }

      expect(state.insync?(is)).to be false
    end

    it 'is synced if hashes are equal' do
      state.should = { 'name' => 'dummy', 'value' => 'resource' }

      is = { 'name' => 'dummy', 'value' => 'resource' }

      expect(state.insync?(is)).to be true
    end

    it 'is synced if hashes are equal but in different order' do
      state.should = { 'name' => 'dummy', 'value' => 'resource' }

      is = { 'value' => 'resource', 'name' => 'dummy' }

      expect(state.insync?(is)).to be true
    end

    it 'is synced if hashes and inner arrays are equal but in different order' do
      state.should = { 'name' => 'dummy', 'value' => %w(b c a) }

      is = { 'value' => %w(a b c), 'name' => 'dummy' }

      expect(state.insync?(is)).to be true
    end

    it 'is synced if desired state is typed but string comparison succeed' do
      state.should = { 'name' => 'dummy', 'port' => 8080, 'enabled' => false }

      is = { 'name' => 'dummy', 'port' => '8080', 'enabled' => 'false' }
      expect(state.insync?(is)).to be true
    end

    it 'is synced if current state is typed but string comparison succeed' do
      state.should = { 'name' => 'dummy', 'port' => '8080', 'enabled' => 'false' }

      is = { 'name' => 'dummy', 'port' => 8080, 'enabled' => false }
      expect(state.insync?(is)).to be true
    end

    it 'is synced if there are unmanaged properties' do
      state.should = { 'name' => 'dummy' }

      is = { 'name' => 'dummy', 'port' => 8080, 'enabled' => false }
      expect(state.insync?(is)).to be true
    end
  end

  describe 'when testing wether the state is in sync with recursive' do
    let(:state) { described_class.new(:resource => resource) }

    it 'is not in sync if hashes do not match' do
      state.should = { 'name' => 'dummy', 'nested-hash' => { 'my-resource' => 'match' } }

      is = { 'name' => 'dummy', 'nested-hash' => { 'my-resource' => 'matchzzz' } }

      expect(state.insync?(is)).to be false
    end

    it 'is synced if hashes are equal' do
      state.should = { 'name' => 'dummy', 'nested-hash' => { 'my-resource' => 'match' } }

      is = { 'name' => 'dummy', 'nested-hash' => { 'my-resource' => 'match' } }

      expect(state.insync?(is)).to be true
    end

    it 'is synced if hashes are equal but in different order' do
      state.should = { 'name' => 'dummy', 'nested-hash' => { 'my-resource' => 'match', 'a-resource' => 'default' }, 'value' => 'resource' }

      is = { 'value' => 'resource', 'name' => 'dummy', 'nested-hash' => { 'a-resource' => 'default', 'my-resource' => 'match' } }

      expect(state.insync?(is)).to be true
    end

    it 'is synced if hashes and inner arrays are equal but in different order' do
      state.should = { 'name' => 'dummy', 'nested-hash' => { 'value' => %w(b c a) } }

      is = { 'nested-hash' => { 'value' => %w(a b c) }, 'name' => 'dummy' }

      expect(state.insync?(is)).to be true
    end

    it 'is synced if hashes and inner arrays are typed but string comparison succeed' do
      state.should = { 'name' => 'dummy', 'nested-hash' => { 'value' => ['true', 'false', 'true'] } }

      is = { 'nested-hash' => { 'value' => [true, false, true] }, 'name' => 'dummy' }

      expect(state.insync?(is)).to be true
    end

    it 'is synced if desired state is typed but string comparison succeed' do
      state.should = { 'name' => 'dummy', 'port' => 8080, 'enabled' => false, 'nested-hash' => { 'enabled' => true, 'a-numeric-resource' => 42 } }

      is = { 'name' => 'dummy', 'port' => '8080', 'enabled' => 'false', 'nested-hash' => { 'enabled' => 'true', 'a-numeric-resource' => '42' } }
      expect(state.insync?(is)).to be true
    end

    it 'is synced if desired state is typed but string comparison succeed with hash inside array' do
      state.should = { 'name' => 'dummy', 'port' => 8080, 'enabled' => false, 'values' => ['nested-hash' => { 'enabled' => true, 'a-numeric-resource' => 42 }] }

      is = { 'name' => 'dummy', 'port' => '8080', 'enabled' => 'false', 'values' => ['nested-hash' => { 'enabled' => 'true', 'a-numeric-resource' => '42' }] }
      expect(state.insync?(is)).to be true
    end

    it 'is synced if current state is typed but string comparison succeed' do
      state.should = { 'name' => 'dummy', 'port' => '8080', 'enabled' => 'false', 'nested-hash' => { 'enabled' => 'true', 'a-numeric-resource' => '42' } }

      is = { 'name' => 'dummy', 'port' => 8080, 'enabled' => false, 'nested-hash' => { 'enabled' => true, 'a-numeric-resource' => 42 } }
      expect(state.insync?(is)).to be true
    end

    it 'is synced if there are unmanaged properties' do
      state.should = { 'name' => 'dummy', 'nested-hash' => { 'enabled' => true } }

      is = { 'name' => 'dummy', 'port' => 8080, 'enabled' => false, 'nested-hash' => { 'enabled' => true, 'a-numeric-resource' => 42 } }
      expect(state.insync?(is)).to be true
    end

    it 'is synced if there are unmanaged hash properties' do
      state.should = { 'name' => 'dummy' }

      is = { 'name' => 'dummy', 'port' => 8080, 'enabled' => false, 'nested-hash' => { 'enabled' => true, 'a-numeric-resource' => 42 } }
      expect(state.insync?(is)).to be true
    end
  end

  describe 'when testing state change notification' do
    let(:state) { described_class.new(:resource => resource) }

    it 'obfuscates sensitive data' do
      current_value = { 'name' => 'dummy', 'nested-hash' => { 'enabled' => true } }
      new_value = { 'name' => 'dummy', 'password' => 'wildflyRocks', 'enabled' => false }

      message = state.change_to_s(current_value, new_value)

      matches = /state changed '(.*)' to '(.*)'/.match(message)

      captured_new_value = JSON.parse(matches[2].gsub('=>', ':'))

      expect(captured_new_value['password']).to eq('******')
    end

    it 'obfuscates new state sensitive data' do
      current_value = { 'name' => 'dummy', 'nested-hash' => { 'enabled' => true } }
      new_value = { 'name' => 'dummy', 'port' => 8080, 'enabled' => false, 'nested-hash' => { 'enabled' => true, 'a-numeric-resource' => 42, 'password' => 'gq!&+Q@!Cy%6Aq>D' } }

      message = state.change_to_s(current_value, new_value)

      matches = /state changed '(.*)' to '(.*)'/.match(message)

      captured_new_value = JSON.parse(matches[2].gsub('=>', ':'))

      expect(captured_new_value['nested-hash']['password']).to eq('******')
    end

    it 'obfuscates current state sensitive data' do
      current_value = { 'name' => 'dummy', 'nested-hash' => { 'enabled' => true, 'password' => 'gq!&+Q@!Cy%6Aq>D' } }
      new_value = { 'name' => 'dummy', 'port' => 8080, 'enabled' => false, 'nested-hash' => { 'enabled' => true, 'a-numeric-resource' => 42 } }

      message = state.change_to_s(current_value, new_value)

      matches = /state changed '(.*)' to '(.*)'/.match(message)

      captured_current_value = JSON.parse(matches[1].gsub('=>', ':'))

      expect(captured_current_value['nested-hash']['password']).to eq('******')
    end
  end
end
