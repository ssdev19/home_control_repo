# Grafana url: http://192.168.0.46:3000
class profile::it::grafana {
  class { 'prometheus::node_exporter':
  version            => '0.12.0',
  collectors_disable => ['loadavg', 'mdadm'],
  extra_options      => '--collector.ntp.server ntp1.orange.intra',
  }
  class { 'grafana':
    version                  => '7.5.3',
    provisioning_datasources => {
    apiVersion  => 1,
    datasources => [
      {
        name      => 'Prometheus',
        type      => 'prometheus',
        access    => 'proxy',
        url       => 'http://prometheus.home.vm:9090/',
        isDefault => true,
      },
    ],
  }
  }

  # firewalld_port { 'Grafana Main Port':
  #   ensure   => present,
  #   port     => '3000',
  #   protocol => 'tcp',
  #   require  => Service['firewalld'],
  # }
}
