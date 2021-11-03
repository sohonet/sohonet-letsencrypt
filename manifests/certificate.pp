# @summary Setup a certificate for with letsencrypt
define letsencrypt::certificate (
  String $site_fqdn,
  String $email,
  Optional[String] $pre_hook = undef,
  Optional[String] $post_hook = undef,
  Optional[String] $alt_names = undef,
  Enum['standalone', 'webroot'] $authenticator = 'standalone',
  Optional[String] $webroot_paths = undef,
) {

  $certbot_pre_hook = $pre_hook ? {
    undef => '/usr/bin/env true',
    default => $pre_hook,
  }

  $certbot_post_hook = $post_hook ? {
    undef => '/usr/bin/env true',
    default => $post_hook,
  }

  $certbot_alt_names = $alt_names ? {
    undef => '',
    default => $alt_names,
  }

  $cerbot_webroot_paths = $webroot_paths ? {
    undef => '',
    default => $webroot_paths,
  }

  file { "${site_fqdn} Cronjob Script":
    ensure  => file,
    content => template('letsencrypt/cronjob.sh.epp'),
    path    => "${letsencrypt::virtualenv_path}/cronjob-${site_fqdn}.sh",
    mode    => '0700',
  }

  file { "${site_fqdn} First Run Script":
    ensure  => file,
    content => template('letsencrypt/firstrun.sh.epp'),
    path    => "${letsencrypt::virtualenv_path}/firstrun-${site_fqdn}.sh",
    mode    => '0700',
  }

  exec { "${site_fqdn} Initial Certbot Run":
    command => "${letsencrypt::virtualenv_path}/firstrun-${site_fqdn}.sh ${letsencrypt::virtualenv_path} ${site_fqdn} ${email} '${certbot_pre_hook}' '${certbot_post_hook}' '${authenticator}' '-w${webroot_paths}' '${alt_names}'",
    creates => "/etc/letsencrypt/renewal/${site_fqdn}.conf",
  }

  cron { "${site_fqdn} Renewal":
    command => "${letsencrypt::virtualenv_path}/cronjob-${site_fqdn}.sh ${letsencrypt::virtualenv_path} ${site_fqdn} '${certbot_pre_hook}' '${certbot_post_hook}'",
    hour    => 12,
    minute  => 0,
    require => Exec["${site_fqdn} Initial Certbot Run"],
  }

}
