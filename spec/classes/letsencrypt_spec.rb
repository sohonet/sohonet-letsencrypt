require 'spec_helper'

describe 'letsencrypt' do
    let(:params) { {
        'site_fqdn' => 'example.foo.com',
    } }

    it { is_expected.to compile.with_all_deps }
end
