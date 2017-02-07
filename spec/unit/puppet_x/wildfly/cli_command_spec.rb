require 'spec_helper'
require 'puppet_x/wildfly/cli_command'

describe PuppetX::Wildfly::CLICommand do
  context 'detyped requests' do
    it 'creates a request for a paramless no parentheses operation' do
      detyped_request = described_class.new(':reload').to_detyped_request

      expect(detyped_request).to eq(:operation => 'reload', :address => [])
    end

    it 'creates a request for a paramless operation' do
      detyped_request = described_class.new(':shutdown').to_detyped_request
      expect(detyped_request).to eq(:operation => 'shutdown', :address => [])
    end

    it 'creates a request for a single param operation' do
      detyped_request = described_class.new(':read-attribute(name=server-state)').to_detyped_request
      expect(detyped_request).to eq(:operation => 'read-attribute', :address => [], 'name' => 'server-state')
    end

    it 'creates a request for a multiple param operation' do
      detyped_request = described_class.new(':read-attribute(name=server-state, include-defaults=true)').to_detyped_request
      expect(detyped_request).to eq(:operation => 'read-attribute', :address => [], 'name' => 'server-state', 'include-defaults' => 'true')
    end

    it 'creates a request for a multiple param operation with headers' do
      detyped_request = described_class.new(':read-attribute(name=server-state, include-defaults=true){header=value;header2=otherValue}').to_detyped_request
      expect(detyped_request).to eq(:operation => 'read-attribute', :address => [], 'name' => 'server-state', 'include-defaults' => 'true', 'operation-headers' => { 'header' => 'value', 'header2' => 'otherValue' })
    end

    it 'creates a request with a target address' do
      detyped_request = described_class.new('/subsystem=web:read-operation-names()').to_detyped_request
      expect(detyped_request).to eq(:operation => 'read-operation-names', :address => [{ 'subsystem' => 'web' }])
    end

    it 'creates a request with a complex target address' do
      detyped_request = described_class.new('/subsystem=web/modcluster=configuration:read-operation-names()').to_detyped_request
      expect(detyped_request).to eq(:operation => 'read-operation-names', :address => [{ 'subsystem' => 'web' }, { 'modcluster' => 'configuration' }])
    end

    it 'creates a request for a resource named with special character' do
      detyped_request = described_class.new('/subsystem=naming/binding="java:global/ldap/resource":add()').to_detyped_request
      expect(detyped_request).to eq(:operation => 'add', :address => [{ 'subsystem' => 'naming' }, { 'binding' => 'java:global/ldap/resource' }])
    end

    it 'creates a request for a complex operation with complex path' do
      detyped_request = described_class.new('/socket-binding-group=standard-sockets/remote-destinations-outbound-socket-binding=mail-smtp:add(host="www-smtp.localdomain", port=25)').to_detyped_request
      expect(detyped_request).to eq(:operation => 'add', :address => [{ 'socket-binding-group' => 'standard-sockets' }, { 'remote-destinations-outbound-socket-binding' => 'mail-smtp' }], 'host' => '"www-smtp.localdomain"', 'port' => '25')
    end
  end
end
