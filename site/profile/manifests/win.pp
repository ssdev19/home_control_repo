class profile::win (String
$psswrd,
) {
  include chocolatey
#  include 'nsclient'
class { 'nsclient':
  allowed_hosts => ['10.21.0.0/22','10.21.4.0/22'],
}
file { 'c:\backups':
  ensure  => directory,
}
user {'bob':
    ensure     => present,
    name       => 'bob',
    groups     => ['Users'],
    password   => $psswrd,
    managehome => false,
}
}
