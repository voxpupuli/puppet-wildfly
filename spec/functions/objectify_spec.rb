# frozen_string_literal: true

describe 'wildfly::objectify' do
  it { is_expected.to run.with_params(['PROTOCOL1', { 'PROTOCOL2' => { 'config' => 'xpto' } }]).and_return({ 'PROTOCOL1' => {}, 'PROTOCOL2' => { 'config' => 'xpto' } }) }
  it { is_expected.to run.with_params(['PROTOCOL1', 'PROTOCOL2']).and_return({ 'PROTOCOL1' => {}, 'PROTOCOL2' => {} }) }
  it { is_expected.to run.with_params([]).and_return({}) }
end
