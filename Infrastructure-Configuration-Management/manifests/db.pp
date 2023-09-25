package { git: }

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

class { '::mysql::server':
  root_password           => '12345',
  remove_default_accounts => true,
  restart                 => true,
  override_options => {
    mysqld => { bind-address => '0.0.0.0'}
  },
}

mysql::db { 'votingtime':
  user        => 'root',
  password    => '12345',
  dbname      => 'votingtime',
  host        => '%',
  sql         => ['/code/app1/db/db_setup.sql'],
  enforce_sql => true,
}

mysql::db { 'tools':
  user        => 'root',
  password    => '12345',
  dbname      => 'tools',
  host        => '%',
  sql         => ['/code/app4/db/db_setup.sql'],
  enforce_sql => true,
}
