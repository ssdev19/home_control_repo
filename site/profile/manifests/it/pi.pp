# Raspberry Pi
class profile::it::pi {

  include ssh
  include timezone
  include accounts
  include network
  # include prometheus::node_exporter
  # class {'::puppet_agent':
  # package_version => '6.21.1',
  # }
# class { 'prometheus::node_exporter':
#   version            => '0.15.0',
#   collectors_disable => ['loadavg', 'mdadm'],
#   extra_options      => '--collector.ntp.server ntp1.orange.intra',
# }
# service { 'Puppet agent':
#   ensure   => running,
#   provider => init,
#   enable   => true,
# }
Package { [ 'tree', 'tcpdump', 'telnet', 'lvm2', 'gcc', 'xinetd',
'bash-completion', 'sudo', 'screen', 'vim', 'openssl',
'acpid', 'wget', 'nmap', 'ifupdown-extra']:
ensure => installed,
}
}
