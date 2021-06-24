# rasbianos 
class profile::it::rasbianos {
  include apache
  include ssh
  include timezone
  include accounts
  include network
  include '::php'
  include '::mysql::server'
class { 'wordpress':

}
Package { [ 'tree', 'tcpdump', 'telnet', 'lvm2', 'gcc', 'xinetd',
'bash-completion', 'sudo', 'screen', 'vim', 'openssl',
'acpid', 'wget', 'nmap', 'ifupdown-extra']:
ensure => installed,
}
}
