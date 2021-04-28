class profile::win {
  include chocolatey
file { 'c:\backups':
  ensure  => directory,
}
}
