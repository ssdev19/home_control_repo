# Applies to all servers
class profile::default {
#  include profile::it::monitoring
# All telegraf configuration came from Hiera
  include ssh
  include timezone
  include accounts

$motd_msg = lookup('motd')
file { '/etc/motd' :
  ensure  => file,
  content => $motd_msg,
}
  # Package { ensure => 'installed' }

  # $enhancers = [ 'tree', 'sssd', 'realmd', 'oddjob', 'oddjob-mkhomedir', 'adcli',
  # 'samba-common', 'samba-common-tools', 'krb5-workstation', 'openldap-clients', 'policycoreutils-python',
  # 'tcpdump', 'openssl', 'openssl-devel', 'telnet', 'acpid', 'lvm2', 'bash-completion', 'sudo', 'vim' ]

  # package { $enhancers: }
  # Firewall and security measurements
  file_line { 'SELINUX=permissive':
    path  => '/etc/selinux/config',
    line  => 'SELINUX=enforce',
    match => '^SELINUX=+',
  }
  $firewall_default_zone = lookup("firewall_default_zone")

  class { 'firewalld':
    service_ensure => lookup('firewalld_status'),
    default_zone   => $firewall_default_zone,
  }

  firewalld_zone { $firewall_default_zone:
  ensure  => present,
  target  => lookup('firewall_default_target'),
  sources => lookup('firewall_default_sources')
  }

  firewalld_service { 'Enable SSH':
  ensure  => 'present',
  service => 'ssh',
  }

# 	firewalld_service { 'Enable DHCP':
# 		ensure  => 'present',
# 		service => 'dhcpv6-client',
# 	}

  exec{'enable_icmp':
    provider => 'shell',
    command  => '/usr/bin/firewall-cmd --add-protocol=icmp --permanent && /usr/bin/firewall-cmd --reload',
    require  => Class['firewalld'],
    onlyif   => "[[ \"\$(firewall-cmd --list-protocols)\" != *\"icmp\"* ]]"
  }
# 	Package { [ 'tree', 'tcpdump', 'telnet', 'lvm2', 'gcc', 'xinetd',
# 'bash-completion', 'sudo', 'screen', 'vim', 'openssl', 'openssl-devel',
# 'acpid', 'wget', 'nmap']:
# ensure => installed,
# }
}
