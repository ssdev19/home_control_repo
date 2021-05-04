class profile::it::pi {

  include ssh
  include timezone
  include accounts
service { 'Puppet agent':
  ensure   => running,
  provider => systemd,
  enable   => true,
}
}
