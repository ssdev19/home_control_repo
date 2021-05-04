class profile::it::pi {

  include ssh
  include timezone
  include accounts
service { 'puppet service':
  ensure   => present,
  provider => systemd
}
}
