require 'spec_helper'
require 'puppet/type'
require 'puppet/type/wildfly_cli'

describe Puppet::Type.type(:wildfly_cli) do
  let(:resource) { Puppet::Type.type(:wildfly_cli).new(name: 'Example Command') }
  let(:provider) { Puppet::Provider.new(resource) }

  before :each do
    resource.provider = provider
  end

  it 'is an instance of Puppet::Type::Wildfly_cli' do
    expect(resource).to be_an_instance_of Puppet::Type::Wildfly_cli
  end

  context 'executed' do
    context 'when `refreshonly` parameter is `true`' do
      before :each do
        resource[:refreshonly] = true
      end

      it 'should not sync' do
        expect(provider).not_to receive(:exec_command)

        resource.property(:executed).sync
      end
    end

    context 'when `refreshonly` parameter is `false`' do
      before :each do
        resource[:refreshonly] = false
      end

      it 'should sync' do
        expect(provider).to receive(:exec_command)

        resource.property(:executed).sync
      end
    end
  end

  context 'when refreshed' do
    context 'when `refreshonly` parameter is `true`' do
      before :each do
        resource[:refreshonly] = true
      end
      context 'and `should_execute?` returns true' do
        it 'runs command' do
          expect(provider).to receive(:should_execute?).and_return(true)
          expect(provider).to receive(:exec_command)

          resource.refresh
        end
      end
      context 'when `should_execute?` returns false' do
        it 'doesn\'t run command' do
          expect(provider).to receive(:should_execute?).and_return(false)
          expect(provider).not_to receive(:exec_command)

          resource.refresh
        end
      end
    end
    context 'when `refreshonly` parameter is `false`' do
      it 'doesn\'t run command' do
        resource[:refreshonly] = false
        expect(provider).not_to receive(:exec_command)

        resource.refresh
      end
    end
  end
end
