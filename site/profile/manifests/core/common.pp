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
class {'::puppet_agent':
  package_version => '6.21.1',
}

file { '/root/secretfile.cfg':
  ensure  => file,
  content => "this string will be encrypted in your catalog\n".node_encrypt::secret
}

Package { [ 'tree', 'tcpdump', 'telnet', 'lvm2', 'gcc', 'xinetd',
'bash-completion', 'sudo', 'screen', 'vim', 'openssl', 'openssl-devel',
'acpid', 'wget', 'nmap']:
ensure => installed,
}
}
