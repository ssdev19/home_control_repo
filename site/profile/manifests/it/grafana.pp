# Grafana url: http://192.168.0.46:3000
class profile::it::grafana (Sensitive[String]
$basedns_hide,
$binddns_hide,
$ldaphost_hide,
){
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
      {
        name      => 'Prometheus-2',
        type      => 'prometheus',
        access    => 'proxy',
        url       => 'http://prometheus2.home.vm:9090/',
        isDefault => false,
      },
    ],
  },
    cfg                      => {
      'auth.ldap' => {
        enabled     => true,
        config_file => '/etc/grafana/ldap.toml',
      },
  }
}
  # firewalld_port { 'Grafana Main Port':
  #   ensure   => present,
  #   port     => '3000',
  #   protocol => 'tcp',
  #   require  => Service['firewalld'],
  # }
}
