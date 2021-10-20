require 'spec_helper'

describe 'letsencrypt' do
    let(:params) { {
        'site_fqdn' => 'example.foo.com',
    } }

    let(:pre_condition) {
        'package { "pipenv": }'
    }

    it { is_expected.to compile.with_all_deps }
end
