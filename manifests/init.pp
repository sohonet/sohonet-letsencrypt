# @summary Manage a letsencrypt setup
class letsencrypt (
  Array $configs,
  String $virtualenv_path = '/var/lib/sohonet-letsencrypt',
  String $certbot_version = 'v1.19.0',
) {

  require ::letsencrypt::install

  file { 'Certbot Config File':
    ensure  => file,
    content => template('letsencrypt/config.ini.epp'),
    path    => "${virtualenv_path}/config.ini",
  }

  $configs.each |Hash $config| {
    $cert_name = $config[site_fqdn]
    letsencrypt::certificate { $cert_name:
      * => $config,
    }
  }

}
