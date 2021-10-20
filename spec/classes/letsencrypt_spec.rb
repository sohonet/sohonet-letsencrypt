require 'spec_helper'

describe 'letsencrypt' do
    let(:params) { {
        'site_fqdn' => 'example.foo.com',
    } }

    context 'With pipenv installed' do
        let(:pre_condition) {
            'package { "pipenv": }'
        }

        it 'should complete basic compilation' do
            is_expected.to compile.with_all_deps
        end
    end

    context 'Without pipenv installed' do
        it 'should fail basic compilation' do
            is_expected.not_to compile
        end
    end

end
