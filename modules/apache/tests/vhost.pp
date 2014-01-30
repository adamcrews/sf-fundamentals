include apache

$my_hosts = [ 'joe.adam.vm', 'bob.adam.vm', 'wat.wat.wat' ]

apache::vhost { $my_hosts: }

apache::vhost { 'wow.boo.boo':
  docroot => '/tmp/wow_root',
}

