class profile::win {
  include chocolatey
  include 'nsclient'

file { 'c:\backups':
  ensure  => directory,
}
}
