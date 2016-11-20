describe 'profile_path' do
  it { is_expected.to run.with_params('').and_return(nil) }
  it { is_expected.to run.with_params(nil).and_return(nil) }
  it { is_expected.to run.with_params('full-ha').and_return('/profile=full-ha') }
end
