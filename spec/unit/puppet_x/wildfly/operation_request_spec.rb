require 'spec_helper'
require 'puppet_x/wildfly/operation_request'

describe PuppetX::Wildfly::OperationRequest do
  context 'when performing requests' do
    let(:api_client) { double('api_client') }
    let(:request) { described_class.new(api_client) }

    it 'exists on successful outcome' do
      resource = '/subsystem=web'
      allow(api_client).to receive(:submit).and_return('outcome' => 'success')
      response = request.exists?(resource)
      expect(response).to be(true)
    end

    it 'does not exists on failed outcome' do
      resource = '/subsystem=web'
      allow(api_client).to receive(:submit).and_return('outcome' => 'failed')
      response = request.exists?(resource)
      expect(response).to be(false)
    end

    it 'executes an arbitrary command' do
      command = '/subsystem=web:read-resource()'
      allow(api_client).to receive(:submit).with(PuppetX::Wildfly::CLICommand.new(command).to_detyped_request, false)
      request.exec(command)
    end

    it 'reads a resource' do
      resource = '/subsystem=web'
      allow(api_client).to receive(:submit).with(PuppetX::Wildfly::OperationBuilder.new.read(resource).with(:recursive => false).build).and_return('result' => {})
      request.read(resource)
    end

    it 'removes a resource' do
      resource = '/subsystem=web'
      allow(api_client).to receive(:submit).with(PuppetX::Wildfly::OperationBuilder.new.remove(resource).headers({}).build)

      request.remove(resource, {})
    end
  end
end
