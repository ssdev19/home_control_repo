class profile::win {
#  include chocolatey
  include 'nsclient'
class { 'nsclient':
  allowed_hosts => ['10.21.0.0/22','10.21.4.0/22'],
}
file { 'c:\backups':
  ensure  => directory,
}
}
