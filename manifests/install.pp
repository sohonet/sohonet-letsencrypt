# @summary Install certbot in a venv
class letsencrypt::install (
) {

  Exec {
    cwd     => $::letsencrypt::virtualenv_path,
    require => Package['pipenv'],
  }

  file { 'Virtual Environment Directory':
    ensure  => directory,
    path    => $::letsencrypt::virtualenv_path,
    require => Package['pipenv'],
  }
  ~> exec { 'Create Virtual Env':
    command     => '/usr/bin/env pipenv --python python3',
    refreshonly => true,
  }
  ~> exec { 'Bootstrap Pip':
    command     => '/usr/bin/env pipenv run pip install --upgrade pip',
    refreshonly => true,
  }
  ~> exec { 'Install Dependencies':
    command     => "/usr/bin/env pipenv run pip install certbot==${::letsencrypt::certbot_version}",
    refreshonly => true,
  }

  if $::letsencrypt::plugin {
    exec { 'Install Plugin':
      command     => "/usr/bin/env pipenv run pip install ${::letsencrypt::plugin}",
      refreshonly => true,
      subscribe   => Exec['Install Dependencies'],
    }
  }

}
