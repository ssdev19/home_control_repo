class profile::win {
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
    password   => lookup('password').node_encrypt::secret,
    managehome => false,
}
}
