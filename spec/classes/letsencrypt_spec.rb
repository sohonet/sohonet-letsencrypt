require 'spec_helper'

describe 'letsencrypt' do
    context 'Without pipenv installed' do
        it 'should fail basic compilation' do
            is_expected.not_to compile
        end
    end

    context 'with multiple certificates' do
        let(:pre_condition) {
            'package { "pipenv": }'
        }

        let(:params) {
            {
                'configs' => [
                    {
                        'site_fqdn' => 'example.foo.com',
                        'email' => 'test@example.com',
                    },
                    {
                        'site_fqdn' => 'example.bar.com',
                        'email' => 'test@bar.com',
                    },
                ],
            }
        }

        it 'should complete basic compilation' do
            is_expected.to compile.with_all_deps
        end
    end

    context 'with multiple certificates and some optional params' do
        let(:pre_condition) {
            'package { "pipenv": }'
        }

        let(:params) {
            {
                'configs' => [
                    {
                        'site_fqdn' => 'example.foo.com',
                        'email' => 'test@example.com',
                        'pre_hook' => '/usr/bin/foo',
                        'post_hook' => '/usr/bin/bar',
                    },
                    {
                        'site_fqdn' => 'example.bar.com',
                        'email' => 'test@bar.com',
                    },
                ]
            }
        }

        it 'should complete basic compilation' do
            is_expected.to compile.with_all_deps
        end

        it 'should not contain any plugin execs' do
            is_expected.not_to contain_exec('Install dns-route53')
        end
    end

    context 'with multiple certificates and all optional params' do
        let(:pre_condition) {
            'package { "pipenv": }'
        }

        let(:params) {
            {
                'configs' => [
                    {
                        'site_fqdn' => 'example.foo.com',
                        'email' => 'test@example.com',
                        'pre_hook' => '/usr/bin/foo',
                        'post_hook' => '/usr/bin/bar',
                    },
                    {
                        'site_fqdn' => 'example.bar.com',
                        'email' => 'test@bar.com',
                        'pre_hook' => '/usr/bin/buzz',
                        'post_hook' => '/usr/bin/baz',
                    },
                ]
            }
        }

        it 'should complete basic compilation' do
            is_expected.to compile.with_all_deps
        end
    end

    context 'with a single plugin' do
        let(:pre_condition) {
            'package { "pipenv": }'
        }

        let(:params) {
            {
                'plugins' => [
                    'dns-route53',
                ],
                'configs' => [
                    {
                        'site_fqdn' => 'example.foo.com',
                        'email' => 'test@example.com',
                        'pre_hook' => '/usr/bin/foo',
                        'post_hook' => '/usr/bin/bar',
                    },
                    {
                        'site_fqdn' => 'example.bar.com',
                        'email' => 'test@bar.com',
                        'pre_hook' => '/usr/bin/buzz',
                        'post_hook' => '/usr/bin/baz',
                    },
                ]
            }
        }

        it 'should complete basic compilation' do
            is_expected.to compile.with_all_deps
        end

        it 'should install the plugin' do
            is_expected.to contain_exec('Install dns-route53')
        end
    end

    context 'with mutliple plugins' do
        let(:pre_condition) {
            'package { "pipenv": }'
        }

        let(:params) {
            {
                'plugins' => [
                    'dns-route53',
                    'dns-route52',
                ],
                'configs' => [
                    {
                        'site_fqdn' => 'example.foo.com',
                        'email' => 'test@example.com',
                        'pre_hook' => '/usr/bin/foo',
                        'post_hook' => '/usr/bin/bar',
                    },
                    {
                        'site_fqdn' => 'example.bar.com',
                        'email' => 'test@bar.com',
                        'pre_hook' => '/usr/bin/buzz',
                        'post_hook' => '/usr/bin/baz',
                    },
                ]
            }
        }

        it 'should complete basic compilation' do
            is_expected.to compile.with_all_deps
        end

        it 'should install the plugins' do
            is_expected.to contain_exec('Install dns-route53')
            is_expected.to contain_exec('Install dns-route52')
        end
    end

end
