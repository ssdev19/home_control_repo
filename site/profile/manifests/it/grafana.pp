# Grafana url: http://192.168.0.46:3000
class profile::it::grafana (Sensitive[String]
$basedns_hide,
$binddns_hide,
$ldaphost_hide,
){
# class { 'prometheus::node_exporter':
#   version            => '0.16.0',
#   collectors_disable => ['loadavg', 'mdadm'],
#   # extra_options      => '--collector.ntp.server ntp1.orange.intra',
# }
  class { 'grafana':
    version => '7.5.3',
    cfg     => {
      'auth.ldap'            => {
      enabled     => true,
      config_file => '/etc/grafana/ldap.toml',
      },
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
#     ldap_cfg                 => {
#       servers          => [
#       { host            => unwrap($ldaphost_hide),
#         port            => 636+0,
#         use_ssl         => true,
#         search_filter   => '(sAMAccountName=%s)',
#         search_base_dns => [ 'dc=domain1,dc=com' ],
#         bind_dn         => unwrap($binddns_hide),
#         bind_password   => unwrap($basedns_hide),
#       },
#   ],
#   'servers.attributes' => {
#     name      => 'givenName',
#     surname   => 'sn',
#     username  => 'sAMAccountName',
#     member_of => 'memberOf',
#     email     => 'email',
#   }
# },
  }
  # firewalld_port { 'Grafana Main Port':
  #   ensure   => present,
  #   port     => '3000',
  #   protocol => 'tcp',
  #   require  => Service['firewalld'],
  # }
}
