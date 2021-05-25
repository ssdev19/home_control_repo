class profile::it::pi {

  include ssh
  include timezone
  include accounts

  package { 'node_exporter':
    ensure => 'absent'
  }
# service { 'Puppet agent':
#   ensure   => running,
#   provider => init,
#   enable   => true,
# }
}
