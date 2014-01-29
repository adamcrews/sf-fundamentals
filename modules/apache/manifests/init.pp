class apache {

  File {
    owner => apache,
    group => apache,
    mode  => '0644',
  }

  package { 'httpd':
    ensure => present,
  }

  file { ['/var/www', '/var/www/html']:
    ensure => directory,
  }

  file { '/var/www/html/index.html':
    ensure => file,
    source => "puppet:///modules/${module_name}/index.html",
  }

  service { 'httpd':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/httpd/conf/httpd.conf'],
  }

  file { '/etc/httpd/conf/httpd.conf':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    source  => "puppet:///modules/${module_name}/httpd.conf",
    require => Package['httpd'],
  }
}
