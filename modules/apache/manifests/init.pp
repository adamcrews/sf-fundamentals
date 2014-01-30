class apache {

  case $::osfamily {
    'redhat': {
      $httpd_user    = 'apache'
      $httpd_group   = 'apache'
      $root_user     = 'root'
      $root_group    = 'root'
      $httpd_pkg     = 'httpd'
      $httpd_svc     = 'httpd'
      $httpd_conf    = 'httpd.conf'
      $httpd_confdir = '/etc/httpd/conf'
      $httpd_conf_d  = '/etc/httpd/conf.d'
      $httpd_mode    = '0644'
      $httpd_base    = '/var/www'
      $httpd_webroot = "${httpd_base}/html"
    }

    'debian': {
      $httpd_user    = 'www-data'
      $httpd_group   = 'www-data'
      $root_user     = 'root'
      $root_group    = 'root'
      $httpd_pkg     = 'apache2'
      $httpd_svc     = 'apache2'
      $httpd_conf    = 'apache2.conf'
      $httpd_confdir = '/etc/apache2'
      $httpd_conf_d  = '/etc/apache2/conf.d'
      $httpd_mode    = '0644'
      $httpd_base    = '/var'
      $httpd_webroot = "${httpd_base}/www"
    }

    'windows': {
      $httpd_user    = undef
      $httpd_group   = undef
      $root_user     = undef
      $root_group    = undef
      $httpd_ver     = '2.2.25'
      $httpd_pkg     = 'httpd-2.2.25-win32-x86-openssl-0.9.8y.msi'
      $httpd_svc     = 'Apache2.2'
      $httpd_conf    = 'httpd.conf'
      $httpd_base    = 'C:\apache'
      $httpd_confdir = "${httpd_base}\\conf"
      $httpd_conf_d  = "${httpd_base}\\conf.d"
      $httpd_mode    = undef
      $httpd_webroot = "${httpd_base}\\htdocs"
    }

    default: {
      fail("${module_name} does not support ${::osfamily}")
    }
  }

  File {
    owner => $httpd_user,
    group => $httpd_group,
    mode  => $httpd_mode,
  }

  include apache::package

  #package { $httpd_pkg:
  #  ensure => present,
  #}

  file { $httpd_webroot:
    ensure  => directory,
    require => Package[$httpd_pkg],
  }

  file { "${httpd_webroot}/index.html":
    ensure => file,
    #source => "puppet:///modules/${module_name}/index.html",
    content => template("${module_name}/index.html.erb"),
  }

  file { $httpd_conf_d:
    ensure  => directory,
    purge   => true,
    recurse => true,
    require => Package[$httpd_pkg],
    notify  => Service[$httpd_svc],
  }

  file { "${httpd_confdir}/${httpd_conf}":
    ensure  => file,
    owner   => $root_user,
    group   => $root_group,
    mode    => $httpd_mode,
    source  => [
        "puppet:///modules/${module_name}/${httpd_conf}.${::osfamily}",
        "puppet:///modules/${module_name}/${httpd_conf}",
      ],
    alias   => 'httpd_config_file',
    require => Package[$httpd_pkg],
  }

  service { $httpd_svc:
    ensure    => running,
    enable    => true,
    subscribe => File['httpd_config_file'],
  }
}
