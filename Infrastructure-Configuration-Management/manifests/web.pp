$packages = [ 'apache2', 'php', 'php-mysql', 'git' ]

package { $packages: }

vcsrepo { '/code':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/shekeriev/do2-app-pack.git',
}

file_line { 'hosts-web':
    ensure => present,
    path   => '/etc/hosts',
    line   => '192.168.69.101  web.do2.exam  web',
    match  => '^192.168.69.101',
}

file_line { 'hosts-db':
    ensure => present,
    path   => '/etc/hosts',
    line   => '192.168.69.102  db.do2.exam  db',
    match  => '^192.168.69.102',
}

file { "/etc/apache2/sites-enabled/vhost-app1.conf":
    ensure => present,
    content => 'Listen 8081
<VirtualHost *:8081>
    DocumentRoot "/var/www/app1"
</VirtualHost>',
} 

file { "/etc/apache2/sites-enabled/vhost-app4.conf":
    ensure => present,
    content => 'Listen 8082
<VirtualHost *:8082>
    DocumentRoot "/var/www/app4"
</VirtualHost>',
} 

file { '/var/www/app1':
  ensure => 'directory',
  recurse => true,
  source => '/code/app1/web/',
}

file { '/var/www/app4':
  ensure => 'directory',
  recurse => true,
  source => '/code/app4/web/',
}
