# For windows computers
class profile::win (String
$psswrd,
) {
  include chocolatey
#  include registry
  include facter

class { 'nsclient':
  allowed_hosts => ['192.168.0.0/24','192.168.1.0/24'],
}
file { 'c:\backups':
  ensure  => directory,
}
file { 'c:\backups\fact.txt':
  ensure  => file,
  content => template('profile/it/testfact.erb')
}
user {'bob':
    ensure     => absent,
    name       => 'bob',
    groups     => ['Users'],
    password   => $psswrd,
    managehome => false,
}
}
