# Grafana url: http://192.168.0.46:3000
class profile::it::grafana (Sensitive[String]
$basedns_hide,
$binddns_hide,
$ldaphost_hide,
){
  class { 'grafana':
    version                  => '8.4.5',
    provisioning_datasources => {
    apiVersion  => 1,
    datasources => [
      {
        name      => 'Prometheus',
        type      => 'prometheus',
        access    => 'proxy',
        url       => 'http://prometheus.home.vm:9090/',
        isDefault => false,
      },
      {
        name      => 'Prometheus-2',
        type      => 'prometheus',
        access    => 'proxy',
        url       => 'http://prometheus2.home.vm:9090/',
        isDefault => true,
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
}
