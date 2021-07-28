# @summary
#   Common functionality needed by standard nodes.
#
# @param collect_metrics
#   Enable or disable metrics collection. Metrics collection may be disabled on development
#   nodes, nodes that don't have uptime requirements, or nodes that should only have minimal
#   software load.
class profile::core::common (
  Boolean $prometheus_target = true,
){
  include timezone
  include node_encrypt::certificates
  include network
  # include tuned
  # include chrony
  # include selinux
  include ::firewalld
  # include irqbalance
  # include sysstat
  # include epel
  # include sudo
  include accounts
  # include puppet_agent
  # include resolv_conf
  include ssh
  # include easy_ipa
  # include augeas
  # include rsyslog
#  include rsyslog::config
#  include profile::core::hardware
#  include profile::core::dielibwrapdie

#  if $collect_metrics {
#    include profile::core::telegraf
#  }
class { 'ntp':
  servers => [ 'time-a-g.nist.gov', 'time-a-wwv.nist.gov', 'time.nist.gov' ],
}
class { 'prometheus::node_exporter':
  version       => '1.1.2',
  extra_options => '--collector.systemd \--collector.processes',
  # collectors_disable => ['loadavg', 'mdadm'],
}
  class {'::puppet_agent':
    package_version => '6.21.1',
  }

  file { '/root/secretfile.cfg':
    ensure  => file,
    content => "this string will be encrypted in your catalog\n".node_encrypt::secret
  }

Package { [ 'tree', 'tcpdump', 'telnet', 'lvm2', 'gcc', 'xinetd',
'bash-completion', 'sudo', 'screen', 'vim', 'openssl', 'openssl-devel',
'acpid', 'wget', 'nmap', 'bind-utils', 'iputils', 'traceroute' ]:
ensure => installed,
}
syslog { "my test":
  ensure          => present,
  facility        => "local2",
  level           => "*",
  action_type     => "hostname",
  action_port     => "5514",
  action_protocol => "tcp",
  action          => "centralserver",
}
}
