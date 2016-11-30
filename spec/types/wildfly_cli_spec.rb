require 'spec_helper'

describe Puppet::Type.type(:wildfly_cli) do
  let(:cli) { Puppet::Type.type(:wildfly_cli) }

  it 'has expected properties' do
    expect(cli.properties.map(&:name)).to include(:executed)
  end

  it 'has expected parameters' do
    expect(cli.parameters).to include(:command, :unless, :onlyif, :username, :password, :host, :port)
  end
end
