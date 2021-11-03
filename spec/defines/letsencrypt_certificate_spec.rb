require 'spec_helper'

describe 'letsencrypt::certificate' do
    let(:title) {
        'sample'
    }

    let(:node_params) {
        {
            'letsencrypt::virtualenv_path' => '/var/lib/sohonet-letsencrypt',
            'letsencrypt::certbot_version' => 'v1.19.0',
        }
    }

    let(:params) {
        {
            'site_fqdn' => 'example.foo.com',
            'email' => 'test@example.com',
        }
    }

    context 'With pipenv installed' do
        let(:pre_condition) {[
                'package { "pipenv": }',
        ]}

        it 'should complete basic compilation' do
            is_expected.to compile.with_all_deps
        end
    end

    context 'with optional params' do
        let(:pre_condition) {[
            'package { "pipenv": }',
        ]}

        let(:params) {
            {
                'site_fqdn' => 'example.foo.com',
                'email' => 'test@example.com',
                'pre_hook' => '/usr/bin/foo',
                'post_hook' => '/usr/bin/bar',
            }
        }

        it 'should complete basic compilation' do
            is_expected.to compile.with_all_deps
        end
    end
end
