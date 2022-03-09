# rasbianos 
class profile::it::rasbianos {
  include apache
  include ssh
  include timezone
  include accounts
  include network
  include '::php'
  include '::mysql::server'
Package { [ 'tree', 'tcpdump', 'telnet', 'lvm2', 'gcc', 'xinetd',
'bash-completion', 'sudo', 'screen', 'vim', 'openssl',
'acpid', 'wget', 'nmap', 'ifupdown-extra', 'traceroute',
'unzip', 'net-tools' ]:
ensure => installed,
}
class { 'chrony':
  servers => [ 'time-a-g.nist.gov', 'time-a-wwv.nist.gov', 'time.nist.gov' ],
}
# config: /etc/systemd/system/node_exporter.service
class { 'prometheus::node_exporter':
  version       => '1.1.2',
  extra_options => '--collector.systemd \--collector.processes \--collector.meminfo_numa',
  # collectors_disable => ['loadavg', 'mdadm'],
  # extra_options      => '--collector.ntp.server ntp1.orange.intra',
}
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
# class { 'phpmyadmin': }
# $db_password = lookup('db_password')
# wordpress::instance { '/var/www/wpbd':
#   wp_owner    => 'wordpress',
#   wp_group    => 'wordpress',
#   db_user     => 'wordpress',
#   db_name     => 'wpbd',
#   db_password => $db_password,
# }

}
