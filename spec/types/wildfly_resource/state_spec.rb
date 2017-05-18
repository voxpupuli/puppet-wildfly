require 'spec_helper'

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

    it 'is synced if hashes are equal including array values' do
      state.should = { 'name' => 'dummy', 'value' => %w(a b c) }

      is = { 'value' => %w(a b c), 'name' => 'dummy' }

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

    it 'is not in sync if nested hashes do not match' do
      state.should = { 'name' => 'dummy', 'nested-hash' => { 'my-resource' => 'match' } }

      is = { 'name' => 'dummy', 'nested-hash' => { 'my-resource' => 'matchzzz' } }

      expect(state.insync?(is)).to be false
    end

    it 'is synced if nested hashes are equal' do
      state.should = { 'name' => 'dummy', 'nested-hash' => { 'my-resource' => 'match' } }

      is = { 'name' => 'dummy', 'nested-hash' => { 'my-resource' => 'match' } }

      expect(state.insync?(is)).to be true
    end

    it 'is synced if hashes are equal but in different order' do
      state.should = { 'name' => 'dummy', 'nested-hash' => { 'my-resource' => 'match', 'a-resource' => 'default' }, 'value' => 'resource' }

      is = { 'value' => 'resource', 'name' => 'dummy', 'nested-hash' => { 'a-resource' => 'default', 'my-resource' => 'match' } }

      expect(state.insync?(is)).to be true
    end

    it 'is synced if hashes and inner arrays are equal' do
      state.should = { 'name' => 'dummy', 'nested-hash' => { 'value' => %w(a b c) } }

      is = { 'nested-hash' => { 'value' => %w(a b c) }, 'name' => 'dummy' }

      expect(state.insync?(is)).to be true
    end

    it 'is synced if hashes and typed inner arrays are equal' do
      state.should = { 'name' => 'dummy', 'nested-hash' => { 'value' => [true, false, true] } }

      is = { 'nested-hash' => { 'value' => [true, false, true] }, 'name' => 'dummy' }

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

end
