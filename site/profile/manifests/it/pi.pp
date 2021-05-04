class profile::it::pi {

  include ssh
  include timezone
  include accounts
service { 'puppet service':
  provider => systemd
#  ensure   => running,
}
}
