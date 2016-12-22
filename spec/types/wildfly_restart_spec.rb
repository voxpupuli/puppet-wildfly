require 'spec_helper'

describe Puppet::Type.type(:wildfly_restart) do
  let(:reload) { Puppet::Type.type(:wildfly_restart) }

  it 'has expected properties' do
    expect(reload.properties.map(&:name)).to include(:pending)
  end

  it 'has expected parameters' do
    expect(reload.parameters).to include(:name, :username, :password, :host, :port, :wait, :retries)
  end
end
