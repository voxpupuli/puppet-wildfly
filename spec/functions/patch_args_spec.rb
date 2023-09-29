# frozen_string_literal: true

describe 'wildfly::patch_args' do
  it { is_expected.to run.with_params('/tmp/patch', false, [], []).and_return('/tmp/patch') }
  it { is_expected.to run.with_params('/tmp/patch', true, [], []).and_return('/tmp/patch --override-all') }
  it { is_expected.to run.with_params('/tmp/patch', false, %w[fileA fileB], []).and_return('/tmp/patch --override=fileA,fileB') }
  it { is_expected.to run.with_params('/tmp/patch', false, [], %w[fileA fileB]).and_return('/tmp/patch --preserve=fileA,fileB') }
  it { is_expected.to run.with_params('/tmp/patch', false, [], %w[fileA fileB]).and_return('/tmp/patch --preserve=fileA,fileB') }
end
