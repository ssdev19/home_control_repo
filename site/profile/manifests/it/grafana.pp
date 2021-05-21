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
    ],
      ldap_cfg  => {
        servers              => [
          { host            => uwrap($ldaphost_hide),
            port            => 389+0,
            use_ssl         => true,
            search_filter   => '(sAMAccountName=%s)',
            search_base_dns => [ unwrap($basedns_hide) ],
            bind_dn         => unwrap($binddns_hide),
          },
        ],
        'servers.attributes' => {
          name      => 'givenName',
          surname   => 'sn',
          username  => 'sAMAccountName',
          member_of => 'memberOf',
          email     => 'email',
        }
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
