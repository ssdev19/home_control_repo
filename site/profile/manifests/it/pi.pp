class profile::it::pi {

  include ssh
  include timezone
  include accounts
service { 'puppet':
  provider => systemd,
  ensure   => running,
}
}
