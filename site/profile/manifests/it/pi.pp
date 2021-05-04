class profile::it::pi {

  include ssh
  include timezone
  include accounts
service { 'puppet service':
  ensure   => running,
  provider => systemd
}
}
