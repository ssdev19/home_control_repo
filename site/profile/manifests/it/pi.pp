# Raspberry Pi
class profile::it::default {
  include ssh
  include timezone
  include accounts
  include network
  include cron
  # $g_ddns = lookup('g_ddns')
# file { '/root/GoDaddy_Bash_DDNS.sh' :
#   ensure  => file,
#   content => $g_ddns,
# }
  # include prometheus::node_exporter
  # class {'::puppet_agent':
  # package_version => '6.21.1',
  # }
# class { 'prometheus::node_exporter':
#   version            => '0.16.0',
#   collectors_disable => ['loadavg', 'mdadm'],
#   extra_options      => '--collector.systemd \--collector.processes \--collector.meminfo_numa',
# }
# service { 'Puppet agent':
#   ensure   => running,
#   provider => init,
#   enable   => true,
# }
Package { [ 'tree', 'tcpdump', 'telnet', 'lvm2', 'gcc', 'xinetd',
'bash-completion', 'sudo', 'screen', 'vim', 'openssl',
'acpid', 'wget', 'nmap', 'ifupdown-extra', 'john',
'unzip', 'net-tools']:
ensure => installed,
}
}
