# @summary
#   Common functionality needed by standard nodes.
#
# @param collect_metrics
#   Enable or disable metrics collection. Metrics collection may be disabled on development
#   nodes, nodes that don't have uptime requirements, or nodes that should only have minimal
#   software load.
class profile::core::common(
  Boolean $collect_metrics = true,
  Sensitive[String[1]] $sensitive_default_some_password,
  Array[String[1], 1]  $default_some_array    = [
    'item1',
    'item2',
  ],
  String[1]            $default_some_username = 'jdoe',
){
  $fog_hash = {
    'default' => {
      'some_array'    => $default_some_array,
      'some_username' => $default_some_username,
      'some_password' => unwrap($sensitive_default_some_password),
    }
  }

  node_encrypt::file { "${agent_home}/.fog":  
    ensure  => file,
    mode    => '0640',
    owner   => 'jenkins',
    group   => 'jenkins',
    content => to_yaml($fog_hash),
    require => User['jenkins'],
  }

  include timezone
  include node_encrypt::certificates
  # include tuned
  # include chrony
  # include selinux
  # include firewall
  # include irqbalance
  # include sysstat
  # include epel
  # include sudo
  include accounts
  # include puppet_agent
  # include resolv_conf
  # include ssh
  # include easy_ipa
  # include augeas
  # include rsyslog
#  include rsyslog::config
#  include profile::core::hardware
#  include profile::core::dielibwrapdie

#  if $collect_metrics {
#    include profile::core::telegraf
#  }

file { '/root/secretfile.cfg':
  ensure  => file,
  content => 'this string will be encrypted  in your catalog'.node_encrypt::secret
}

  Package { [ 'tree', 'tcpdump', 'telnet', 'lvm2', 'gcc', 'xinetd',
'bash-completion', 'sudo', 'screen', 'vim', 'openssl', 'openssl-devel',
'acpid', 'wget', 'nmap']:
ensure => installed,
}
}
