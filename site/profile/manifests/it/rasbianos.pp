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
'acpid', 'wget', 'nmap', 'ifupdown-extra', 'traceroute', 'unzip' ]:
ensure => installed,
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
