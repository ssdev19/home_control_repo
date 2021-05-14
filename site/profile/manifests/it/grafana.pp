class profile::it::grafana {
  class { 'grafana':
    version                  => '7.5.3',
    provisioning_datasources => {
    apiVersion  => 1,
    datasources => [
      {
        name      => 'Prometheus',
        type      => 'prometheus',
        access    => 'proxy',
        url       => 'http://localhost:9090/prometheus',
        isDefault => true,
      },
    ],
  }
  }

  firewalld_port { 'Grafana Main Port':
    ensure   => present,
    port     => '3000',
    protocol => 'tcp',
    require  => Service['firewalld'],
  }
}
