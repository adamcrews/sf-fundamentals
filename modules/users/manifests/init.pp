class users {

  user { 'fundamentals':
    ensure     => present,
    comment    => "${::fqdn} - Fundamentals user",
    uid        => '1023',
    gid        => 'sysadmin',
    home       => '/home/fun',
    managehome => true,
  }

  group { 'sysadmin':
    ensure => present,
    gid    => '1024',
  }

  group { 'elvis':
    ensure => absent,
    gid    => '9999',
  }

  group { 'tcpdump':
    ensure => present,
    gid    => '9919',
  }
}
