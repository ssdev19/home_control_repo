# Applies to all servers
class profile::default {
  # include profile::it::monitoring
# All telegraf configuration came from Hiera
  include ssh
  include timezone
  include accounts
  include network
class { 'ntp':
  servers => [ 'time-a-g.nist.gov', 'time-a-wwv.nist.gov', 'time.nist.gov' ],
}
  # include prometheus::node_exporter
class { 'prometheus::node_exporter':
  version            => '1.1.2',
  # collectors_disable => ['loadavg', 'mdadm'],
  # extra_options      => '--collector.ntp.server ntp1.orange.intra',
}
  #   $fqdn = $::fqdn
  # profile::it::prometheus::target: { "${fqdn} - node_exporter":
  #   job  => 'node',
  #   host => "${fqdn}:9100",
  # }

$motd_msg = lookup('motd')
file { '/etc/motd' :
  ensure  => file,
  content => $motd_msg,
}
$hosts = lookup ('hosts')
file { '/etc/hosts' :
  ensure  => file,
  content => $hosts,
}
Package { [ 'tree', 'tcpdump', 'telnet', 'lvm2', 'gcc', 'xinetd',
'bash-completion', 'sudo', 'ntpd', 'screen', 'vim', 'openssl', 'openssl-devel',
'acpid', 'wget', 'nmap', 'bind-utils', 'iputils']:
ensure => installed,
}
  # Firewall and security measurements
  # file_line { 'SELINUX=permissive':
  #   path  => '/etc/selinux/config',
  #   line  => 'SELINUX=enforce',
  #   match => '^SELINUX=+',
  # }
  $firewall_default_zone = lookup('firewall_default_zone')

  # class { 'firewalld':
  #   service_ensure => lookup('firewalld_status'),
  #   default_zone   => $firewall_default_zone,
  # }

  # firewalld_zone { $firewall_default_zone:
  # ensure  => present,
  # target  => lookup('firewall_default_target'),
  # sources => lookup('firewall_default_sources')
  # }

  # firewalld_service { 'Enable SSH':
  # ensure  => 'present',
  # service => 'ssh',
  # }

# 	firewalld_service { 'Enable DHCP':
# 		ensure  => 'present',
# 		service => 'dhcpv6-client',
# 	}

  # exec{'enable_icmp':
  #   provider => 'shell',
  #   command  => '/usr/bin/firewall-cmd --add-protocol=icmp --permanent && /usr/bin/firewall-cmd --reload',
  #   require  => Class['firewalld'],
  #   onlyif   => "[[ \"\$(firewall-cmd --list-protocols)\" != *\"icmp\"* ]]"
  # }
# 	Package { [ 'tree', 'tcpdump', 'telnet', 'lvm2', 'gcc', 'xinetd',
# 'bash-completion', 'sudo', 'screen', 'vim', 'openssl', 'openssl-devel',
# 'acpid', 'wget', 'nmap']:
# ensure => installed,
# }
}
