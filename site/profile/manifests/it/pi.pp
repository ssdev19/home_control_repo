class profile::it::pi {

  include ssh
  include timezone
  include accounts
  # include prometheus::node_exporter
  # class {'::puppet_agent':
  # package_version => '6.21.1',
  # }

# service { 'Puppet agent':
#   ensure   => running,
#   provider => init,
#   enable   => true,
# }
}
