# @summary Manage a letsencrypt setup
class letsencrypt (
  $site_fqdn,
  Array $commandline_args = [],
  Boolean $disable_all_flags = false,
  $virtualenv_path = '/var/letsencrypt',
  String $certbot_version = 'v1.19.0',
) {

  Exec {
    cwd => $virtualenv_path,
  }

  file { 'Virtual Environment Directory':
    ensure => directory,
    path   => $virtualenv_path,
  }
  ~> exec { 'Create Virtual Env':
    command      => '/usr/bin/env pipenv --python python3',
  }
  -> exec { 'Bootstrap Pip':
    command => '/usr/bin/env pipenv run pip install --upgrade pip',
  }
  -> exec { 'Install Dependencies':
    command => "/usr/bin/env pipenv run pip install certbot==${certbot_version}",
  }

  file { 'Certbot Config File':
    ensure  => file,
    content => template('letsencrypt/config.ini.erb'),
    path    => "${virtualenv_path}/config.ini",
  }

}
