class profile::it::pi {

  include ssh
  include timezone
  include accounts
  # include prometheus::node_exporter
  # class {'::puppet_agent':
  # package_version => '6.21.1',
  # }
class { 'prometheus::node_exporter':
  version            => '0.15.0',
  collectors_disable => ['loadavg', 'mdadm'],
  extra_options      => '--collector.ntp.server ntp1.orange.intra',
}
# service { 'Puppet agent':
#   ensure   => running,
#   provider => init,
#   enable   => true,
# }
}
