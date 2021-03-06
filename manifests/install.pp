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
  ~> exec { 'Install Certbot':
    command     => "/usr/bin/env pipenv run pip install certbot==${::letsencrypt::certbot_version}",
    refreshonly => true,
  }

  $::letsencrypt::plugins.each |$plugin| {
    exec { "Install ${plugin}":
      command     => "/usr/bin/env pipenv run pip install certbot-${plugin}",
      refreshonly => true,
      subscribe   => Exec['Bootstrap Pip'],
      require     => Exec['Bootstrap Pip'],
    }
  }

}
