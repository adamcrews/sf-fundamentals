class apache::package {
  case $::osfamily {
    'windows': {
      $apache_mirror  = 'http://archive.apache.org/dist/httpd/binaries/win32'

      exec { 'Download Apache':
        command   => "powershell.exe -Command (new-object System.Net.WebClient).DownloadFile(\'${apache_mirror}/${apache::httpd_pkg}\', \'C:\\${apache::httpd_pkg}\')",
        path      => 'C:\Windows\System32\WindowsPowerShell\v1.0',
        creates   => "C:\\${apache::httpd_pkg}",
        logoutput => true,
      }

      package { $apache::httpd_pkg:
        ensure           => present,
        name             => "Apache HTTP Server ${apache::httpd_ver}",
        source           => "C:\\${apache::httpd_pkg}",
        require          => Exec['Download Apache'],
        install_options  => {
          'SERVERADMIN'  => 'admin@localhost',
          'ALLUSERS'     => '1',
          'SERVERNAME'   => 'localhost',
          'SERVERDOMAIN' => 'localhost',
          'SERVERPORT'   => '80',
          'INSTALLDIR'   => $apache::httpd_base,
        },
      }
    }

    default: {
      package { $apache::httpd_pkg:
        ensure => installed,
      }
    }
  }
}
