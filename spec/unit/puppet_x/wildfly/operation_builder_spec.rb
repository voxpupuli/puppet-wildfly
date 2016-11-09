require 'spec_helper'

describe PuppetX::Wildfly::OperationBuilder do
  context 'when building requests' do
    it 'creates an empty add request' do
      operation_builder = described_class.new
      operation = operation_builder.add('/subsystem=web').build

      expect(operation).to eq(:address => [{ 'subsystem' => 'web' }], :operation => :add)
    end

    it 'creates an add request' do
      operation_builder = described_class.new
      state = { 'param' => 'value', 'param2' => 'value' }
      operation = operation_builder.add('/subsystem=web').with(state).build

      expect(operation).to eq(:address => [{ 'subsystem' => 'web' }], :operation => :add, 'param' => 'value', 'param2' => 'value')
    end

    it 'creates a remove request' do
      operation_builder = described_class.new
      operation = operation_builder.remove('/subsystem=web').build

      expect(operation).to eq(:address => [{ 'subsystem' => 'web' }], :operation => :remove)
    end

    it 'creates a paramless read request' do
      operation_builder = described_class.new
      operation = operation_builder.read('/subsystem=web').build

      expect(operation).to eq(:address => [{ 'subsystem' => 'web' }], :operation => 'read-resource')
    end

    it 'creates a recursive read request' do
      operation_builder = described_class.new
      operation = operation_builder.read('/subsystem=web').with(:recursive => true).build

      expect(operation).to eq(:address => [{ 'subsystem' => 'web' }], :operation => 'read-resource', :recursive => true)
    end

    it 'creates an add request with content' do
      operation_builder = described_class.new
      operation = operation_builder.add_content('hawtio.war', 'file:/tmp/hawtio.war').build

      expect(operation).to eq(:operation => :add, :content => [:url => 'file:/tmp/hawtio.war'], :address => [{ :deployment => 'hawtio.war' }])
    end

    it 'creates a deploy request' do
      operation_builder = described_class.new
      operation = operation_builder.deploy('myapp.ear').build

      expect(operation).to eq(:operation => :deploy, :address => [:deployment => 'myapp.ear'])
    end

    it 'creates a composite request' do
      add_operation_builder = described_class.new
      add_operation = add_operation_builder.add_content('hawtio.war', 'file:/tmp/hawtio.war').build

      deploy_operation_builder = described_class.new
      deploy_operation = deploy_operation_builder.deploy('hawtio.war').build

      operation_builder = described_class.new
      operation = operation_builder.composite(add_operation, deploy_operation).build

      expect(operation).to eq(:address => [], :operation => :composite, :steps => [add_operation, deploy_operation])
    end
  end
end
