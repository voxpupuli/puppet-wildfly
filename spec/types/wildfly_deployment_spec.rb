require 'spec_helper'

describe Puppet::Type.type(:wildfly_deployment) do
  let(:deployment) { Puppet::Type.type(:wildfly_deployment) }

  it 'has expected properties' do
    expect(deployment.properties.map(&:name)).to include(:content)
  end

  it 'has expected parameters' do
    expect(deployment.parameters).to include(:name, :source, :server_group, :username, :password, :host, :port, :timeout, :operation_headers)
  end

  describe 'when testing wether content checksum is in sync' do
    let(:resource) { described_class.new(:name => 'app.ear') }

    it 'is if deployed content SHA1 checksum matches source checksum' do
      resource[:source] = 'file:/tmp/app.ear'
    end
  end

  describe 'when validating parameters' do
    let(:catalog) { Puppet::Resource::Catalog.new }
    let(:resource) { described_class.new(:name => 'app.war', :catalog => catalog) }

    it 'operation headers is valid if it is a Hash' do
      expect { resource[:operation_headers] = {} }.not_to raise_error
    end

    it 'operation headers is not valid if its not a Hash' do
      expect { resource[:operation_headers] = 'teste' }.to raise_error(Puppet::ResourceError)
    end
  end

  describe 'content property' do
    let(:file_deployment) { described_class.new(:name => 'file', :source => File.expand_path('LICENSE')) }
    let(:content) { described_class.attrclass(:content).new(:resource => file_deployment) }

    it 'is in sync if checksum is equal' do
      expect(content.insync?('2b8b815229aa8a61e483fb4ba0588b8b6c491890')).to be(true)
    end

    it 'it is not in sync if checksum is different' do
      expect(content.insync?('033477d1d856776cdeb582a289d75804415158b1')).to be(false)
    end

    it 'print new value as checksum of the source' do
      expect(content.change_to_s('033477d1d856776cdeb582a289d75804415158b1', nil)).to include('2b8b815229aa8a61e483fb4ba0588b8b6c491890')
    end
  end
end
