require 'spec_helper'

describe Puppet::Type.type(:wildfly_resource) do
  let(:resource) { Puppet::Type.type(:wildfly_resource) }

  it 'has expected properties' do
    expect(resource.properties.map(&:name)).to include(:state)
  end

  it 'has expected parameters' do
    expect(resource.parameters).to include(:path, :username, :password, :host, :port, :recursive, :operation_headers)
  end

  describe 'when validating parameters' do
    let(:catalog) { Puppet::Resource::Catalog.new }
    let(:resource) { described_class.new(:path => '/subsystem=dummy', :catalog => catalog) }

    it 'path is valid if forms a valid JBoss resource path' do
      expect { resource[:path] = '/subsystem=web' }.not_to raise_error
    end

    it 'path is valid if forms a long valid JBoss resource path' do
      expect { resource[:path] = '/profile=full-ha/subsystem=web/configuration=jsp-configuration' }.not_to raise_error
    end

    it 'path is not valid if it does not form a JBoss resource path' do
      expect { resource[:path] = 'subsystem=web' }.to raise_error(Puppet::ResourceError)
    end

    it 'operation headers is valid if it is a Hash' do
      expect { resource[:operation_headers] = {} }.not_to raise_error
    end

    it 'operation headers is not valid if its not a Hash' do
      expect { resource[:operation_headers] = 'teste' }.to raise_error(Puppet::ResourceError)
    end
  end
end
