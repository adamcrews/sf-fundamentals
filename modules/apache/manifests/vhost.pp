define apache::vhost (
  $docroot      = "${apache::httpd_base}/${name}",
  $port         = '80',
  $conf_d       = $apache::httpd_conf_d,
  $priority     = '10',
  $options      = 'Indexes MultiViews',
  $vhost_name   = $name,
  $server_name  = $name,
  $root_user    = $apache::root_user,
  $root_group   = $apache::root_group,
  $httpd_user   = $apache::httpd_user,
  $httpd_group  = $apache::httpd_group,
) {

  # Install the vhost config file
  file { "${conf_d}/${priority}_${name}.conf":
    ensure  => file,
    owner   => $root_user,
    group   => $root_group,
    content => template("${module_name}/vhost.conf.erb"),
    require => Package[$apache::httpd_pkg],
    notify  => Service[$apache::httpd_svc],
  }

  if (! defined(File[$docroot])) {
    file { $docroot:
      ensure  => directory,
      owner   => $httpd_user,
      group   => $httpd_group,
      require => Package[$apache::httpd_pkg],
    }

    file { "${docroot}/index.html":
      ensure  => file,
      owner   => $httpd_user,
      group   => $httpd_group,
      content => template("${module_name}/index.html.erb"),
    }
  }

  host { $vhost_name:
    ensure => present,
    ip     => $::ipaddress,
  }

}
