class profile::it::grafana {
  class { 'grafana':
    version  => '7.5.3'
  }

  firewalld_port { 'Grafana Main Port':
    ensure   => present,
    port     => '3000',
    protocol => 'tcp',
    require  => Service['firewalld'],
  }
}
