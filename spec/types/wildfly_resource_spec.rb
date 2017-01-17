require 'spec_helper'

describe Puppet::Type.type(:wildfly_resource) do
  let(:resource) { Puppet::Type.type(:wildfly_resource) }

  it 'has expected properties' do
    expect(resource.properties.map(&:name)).to include(:state)
  end

  it 'has expected parameters' do
    expect(resource.parameters).to include(:path, :username, :password, :host, :port, :recursive, :operation_headers)
  end

  it 'allow same path for different hosts' do
    catalog = Puppet::Resource::Catalog.new

    expect { catalog.add_resource(described_class.new(:title => '/subsystem=web:127.0.0.1'), described_class.new(:title => '/subsystem=web:192.168.33.10')) }.not_to raise_error
  end

  it 'allow same path for different hosts 2' do
    catalog = Puppet::Resource::Catalog.new

    expect { catalog.add_resource(described_class.new(:title => '/subsystem=datasources/data-source=DemoDS'), described_class.new(:title => '/subsystem=datasources/data-source=MyDS')) }.not_to raise_error
  end

  describe 'when using composite title' do
    it 'simple title pattern containing only path' do
      simple_resource = described_class.new(:title => '/profile=full-ha/subsystem=web/configuration=jsp-configuration')
      expect(simple_resource[:path]).to eq('/profile=full-ha/subsystem=web/configuration=jsp-configuration')
      expect(simple_resource[:host]).to eq('127.0.0.1')
      expect(simple_resource[:port]).to eq(9990)
    end

    it 'composite title with path and host' do
      resource_with_composite_name = described_class.new(:title => '/profile=full-ha/subsystem=web/configuration=jsp-configuration:192.168.0.10')
      expect(resource_with_composite_name[:path]).to eq('/profile=full-ha/subsystem=web/configuration=jsp-configuration')
      expect(resource_with_composite_name[:host]).to eq('192.168.0.10')
      expect(resource_with_composite_name[:port]).to eq(9990)
    end

    it 'composite title with path, host, and port' do
      resource_with_composite_name = described_class.new(:title => '/profile=full-ha/subsystem=web/configuration=jsp-configuration:192.168.30.20:10990')
      expect(resource_with_composite_name[:path]).to eq('/profile=full-ha/subsystem=web/configuration=jsp-configuration')
      expect(resource_with_composite_name[:host]).to eq('192.168.30.20')
      expect(resource_with_composite_name[:port]).to eq(10_990)
    end

    it 'composite fail with invalid path' do
      expect { described_class.new(:title => 'profile=full') }.to raise_error(Puppet::ResourceError)
    end
  end

  describe 'when validating parameters' do
    let(:catalog) { Puppet::Resource::Catalog.new }
    let(:resource) { described_class.new(:title => '/subsystem=dummy', :catalog => catalog) }

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
