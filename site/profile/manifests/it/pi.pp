class profile::it::pi {

  include ssh
  include timezone
  include accounts

class { 'prometheus::node_exporter':
  version            => '0.12.0',
  collectors_disable => ['loadavg', 'mdadm'],
  extra_options      => '--prometheus.home.vm',
}
# service { 'Puppet agent':
#   ensure   => running,
#   provider => init,
#   enable   => true,
# }
}
