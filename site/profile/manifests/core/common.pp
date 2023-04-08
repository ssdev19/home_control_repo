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
  # include ::openssl
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
  include rsyslog::config
#  include profile::core::hardware
#  include profile::core::dielibwrapdie

#  if $collect_metrics {
#    include profile::core::telegraf
#  }
class { 'chrony':
  servers => [ 'time-a-g.nist.gov', 'time-a-wwv.nist.gov', 'time.nist.gov' ],
}
class { 'prometheus::node_exporter':
  version       => '1.3.1',
  extra_options => '--collector.systemd \--collector.processes',
  # collectors_disable => ['loadavg', 'mdadm'],
}
  # class {'::puppet_agent':
  #   package_version => '6.26.0',
  # }

  file { '/root/secretfile.cfg':
    ensure  => file,
    content => "this string will be encrypted in your catalog\n".node_encrypt::secret
  }

Package { [ 'tree', 'tcpdump', 'telnet', 'lvm2', 'gcc', 'xinetd',
'bash-completion', 'sudo', 'vim', 'openssl', 'openssl-devel',
'acpid', 'wget', 'nmap', 'bind-utils', 'iputils', 'traceroute',
'yum-utils' ]:
ensure => latest,
}
# *.* @graylog-tuc.lsst.org:5514;RSYSLOG_SyslogProtocol23Format
# class { 'archive':
#   archives => { '/tmp/openssl-1.1.1k.tar.gz' => {
#                   'ensure'  => 'present',
#                   'source'  => 'https://www.openssl.org/source/openssl-1.1.1k.tar.gz',
#                   'extract' => true,
#                   'extract_path' => '/usr/local/',
#                   'creates'      => '/usr/local/ssl/openssl-1.1.1',
#                   }, }
#   }
  # class { '::openssl':
  #   package_ensure         => present,
  #   ca_certificates_ensure => present,
  # }
}
