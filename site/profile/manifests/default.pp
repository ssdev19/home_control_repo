# Applies to all servers
class profile::default {
  # include profile::it::monitoring
# All telegraf configuration came from Hiera
  include ssh
  include timezone
  include accounts
  include network
  include ::firewalld
Package { [ 'git', 'tree', 'tcpdump', 'telnet', 'lvm2', 'gcc', 'xinetd',
'bash-completion', 'sudo', 'screen', 'vim', 'openssl', 'openssl-devel',
'acpid', 'wget', 'nmap', 'bind-utils', 'iputils', 'traceroute' ]:
ensure => installed,
}
class { 'ntp':
  servers => [ 'time-a-g.nist.gov', 'time-a-wwv.nist.gov', 'time.nist.gov' ],
}
# config: /etc/systemd/system/node_exporter.service
class { 'prometheus::node_exporter':
  version       => '1.1.2',
  extra_options => '--collector.systemd \--collector.processes \--collector.meminfo_numa',
  # collectors_disable => ['loadavg', 'mdadm'],
  # extra_options      => '--collector.ntp.server ntp1.orange.intra',
}
  # class {'::puppet_agent':
  #   package_version => '6.24.0',
  # }
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
$sshd_banner_content = lookup('sshd_banner_content')
file { '/etc/ssh/sshd_banner' :
  ensure  => file,
  content => $sshd_banner_content,
}
$hosts = lookup ('hosts')
file { '/etc/hosts' :
  ensure  => file,
  content => $hosts,
}
$denyhosts = lookup ('denyhosts')
file { '/etc/hosts.deny' :
  ensure  => file,
  content => $denyhosts,
}
$allowhosts = lookup ('allowhosts')
file { '/etc/hosts.allow' :
  ensure  => file,
  content => $allowhosts,
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
