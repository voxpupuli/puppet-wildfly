require 'spec_helper'

describe Puppet::Type.type(:wildfly_resource) do
  let(:resource_class) { Puppet::Type.type(:wildfly_resource) }

  describe 'path validation' do
    context 'with valid paths' do
      [
        '/system-property="app/config/path"',
        '/system-property=log4j2.formatMsgNoLookups',
        '/subsystem=modcluster/mod-cluster-config=configuration',
        '/subsystem=datasources/data-source=java:jboss/datasources/ExampleDS',
        '/core-service=management/security-realm=ApplicationRealm/server-identity=ssl',
        '/subsystem=undertow/server=default-server/host=default-host/location=" / "',
      ].each do |path|
        it "accepts #{path}" do
          expect do
            resource_class.new(title: path, state: { 'value' => 'true' })
          end.not_to raise_error
        end
      end
    end

    context 'with invalid paths' do
      [
        '/subsystem=modcluster/key=value=extra',
        '/subsystem=modcluster/invalid!key=value',
        '/subsystem=modcluster/key="unclosed-quote',
        'subsystem=modcluster',
        '/subsystem',
        '/subsystem=modcluster/mod-cluster-config=',
      ].each do |path|
        it "rejects #{path}" do
          expect do
            resource_class.new(title: path, state: { 'value' => 'true' })
          end.to raise_error(Puppet::Error, %r{Invalid resource path})
        end
      end
    end
  end
end
