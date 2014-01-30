class hosts {

  host { $::fqdn:
    ensure       => 'present',
    host_aliases => [$::hostname],
    ip           => $::ipaddress,
  }

  host { 'localhost.localdomain':
    ensure       => 'present',
    host_aliases => ['localhost4', 'localhost4.localdomain4', 'localhost'],
    ip           => '127.0.0.1',
  }

  host { 'localhost6.localdomain6':
    ensure       => present,
    host_aliases => ['localhost6'],
    ip           => '::1',
  }

  host { 'master.puppetlabs.vm':
    ensure       => 'present',
    host_aliases => ['master', 'puppet.puppetlabs.vm', 'puppet'],
    ip           => '10.0.1.3',
  }

  resources { 'host': 
    purge => true,
  }
}
