class website {
  include apache

  class { '::mysql::server':
    root_password    => 'strongpassword',
    override_options => { 'mysqld' => { 'max_connections' => '1024' } },
  }

  class { '::mysql::bindings':
    php_enable => true,
  }

  class { 'wordpress':
    install_dir => '/var/www/wordpress',
  }

  apache::vhost { 'adam.wp.vm':
    docroot => '/var/www/wordpress',
  }

  Class['apache'] -> Class['wordpress']

}
