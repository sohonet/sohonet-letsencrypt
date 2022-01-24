require 'spec_helper'

describe 'letsencrypt::certificate' do
    $site_fqdn = 'example.foo.com'

    let(:title) { $site_fqdn }

    let(:node_params) {
        {
            'letsencrypt::virtualenv_path' => '/var/lib/sohonet-letsencrypt',
            'letsencrypt::certbot_version' => 'v1.19.0',
        }
    }

    let(:params) {
        {
            'site_fqdn' => $site_fqdn,
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
                'site_fqdn' => $site_fqdn,
                'email' => 'test@example.com',
                'pre_hook' => '/usr/bin/foo',
                'post_hook' => '/usr/bin/bar',
            }
        }

        it 'should complete basic compilation' do
            is_expected.to compile.with_all_deps
        end
    end

    context 'with dns authenticator' do
        let(:pre_condition) {[
            'package { "pipenv": }',
        ]}

        let(:params) {
            {
                'site_fqdn' => $site_fqdn,
                'email' => 'test@example.com',
                'authenticator' => 'dns-route53',
            }
        }

        it 'should complete basic compilation' do
            is_expected.to compile.with_all_deps
        end

        it 'should have a config file' do
            $filename = $site_fqdn + " Config File"
            is_expected.to contain_file($filename).with(
                content: 'key-type = ecdsa
elliptic-curve = secp384r1
authenticator = dns-route53
preferred-chain = "ISRG Root X1"
'
            )
        end
    end
end
