require 'spec_helper'

provider_class = Puppet::Type.type(:wildfly_deployment).provider(:http_api)

describe provider_class do
  let :resource do
    Puppet::Type.type(:wildfly_deployment).new(
      :name              => 'test.ear',
      :source            => '/tmp/test.ear',
      :operation_headers => {},
      :provider          => :http_api)
  end

  let :provider do
    resource.provider
  end

  describe 'content=' do
    describe 'undeploy_first' do
      context 'by default' do
        it 'undeploy_first is false' do
          expect(resource[:undeploy_first]).to be(false)
        end
        it 'calls `update_deploy`' do
          expect(provider).not_to receive(:destroy)
          expect(provider).not_to receive(:create)

          cli = double
          allow(provider).to receive(:cli).and_return(cli)

          expect(provider.cli).to receive(:update_deploy).with('test.ear', '/tmp/test.ear', nil, {})
          provider.content = 'unused'
        end
      end
      context 'when undeploy_first => true' do
        it 'calls `destroy` followed by `create`' do
          resource[:undeploy_first] = true
          expect(provider).to receive(:destroy).ordered
          expect(provider).to receive(:create).ordered
          provider.content = 'unused'
        end
      end
    end
  end
end
