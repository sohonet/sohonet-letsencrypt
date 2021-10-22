# @summary Manage a letsencrypt setup
class letsencrypt (
  $site_fqdn,
  String $email,
  Optional[String] $pre_hook = undef,
  Optional[String] $post_hook = undef,
  $virtualenv_path = '/var/lib/sohonet-letsencrypt',
  String $certbot_version = 'v1.19.0',
) {

  $certbot_pre_hook = $pre_hook ? {
    undef => '/usr/bin/true',
    default => $pre_hook,
  }

  $certbot_post_hook = $post_hook ? {
    undef => '/usr/bin/true',
    default => $post_hook,
  }

  Exec {
    cwd     => $virtualenv_path,
    require => Package['pipenv'],
  }

  file { 'Virtual Environment Directory':
    ensure  => directory,
    path    => $virtualenv_path,
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
    command     => "/usr/bin/env pipenv run pip install certbot==${certbot_version}",
    refreshonly => true,
  }

  file { 'Certbot Config File':
    ensure  => file,
    content => template('letsencrypt/config.ini.erb'),
    path    => "${virtualenv_path}/config.ini",
    require => File['Virtual Environment Directory'],
  }

  file { 'Certbot Cronjob Script':
    ensure  => file,
    source  => 'puppet:///modules/letsencrypt/cronjob.sh',
    path    => "${virtualenv_path}/cronjob.sh",
    require => File['Virtual Environment Directory'],
    mode    => '0700',
  }

  file { 'Certbot First Run Script':
    ensure  => file,
    source  => 'puppet:///modules/letsencrypt/firstrun.sh',
    path    => "${virtualenv_path}/firstrun.sh",
    require => File['Virtual Environment Directory'],
    mode    => '0700',
  }

  exec { 'Initial Certbot Run':
    command => "${virtualenv_path}/firstrun.sh ${virtualenv_path} ${site_fqdn} ${email} ${certbot_pre_hook} ${certbot_post_hook}",
    creates => "/etc/letsencrypt/renewal/${site_fqdn}.conf",
    require => [
      File['Virtual Environment Directory'],
      Exec['Install Dependencies'],
    ]
  }

  cron { 'Certbot Renewal':
    command => "${virtualenv_path}/cronjob.sh ${virtualenv_path} ${site_fqdn} ${certbot_pre_hook} ${certbot_post_hook}",
    hour    => 12,
    require => Exec['Initial Certbot Run'],
  }
}
