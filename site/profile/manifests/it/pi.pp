class profile::it::pi {

  include ssh
  include timezone
  include accounts
  include node_exporter
# service { 'Puppet agent':
#   ensure   => running,
#   provider => init,
#   enable   => true,
# }
}
