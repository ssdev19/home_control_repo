# For windows computers
class profile::win (Sensitive
$psswrd_encrypt,
$secretcontent_encrypt,
) {
  include chocolatey
#  include registry
  include facter
  include accounts
facter::fact { 'symantec_defenition_version':
  value => 'test',
}

class { 'nsclient':
  allowed_hosts => ['192.168.0.0/24','192.168.1.0/24'],
}
# file { 'c:\backups':
#   ensure  => directory,
# }
# file { 'c:\backups\encrypted.txt':
#   ensure  => file,
#   content => unwrap($secretcontent_encrypt).node_encrypt::secret
# }
# file { 'c:\backups\fact.txt':
#   ensure  => file,
#   content => template('profile/it/testfact.erb')
# }
user {'bob':
    ensure     => absent,
    name       => 'bob',
    groups     => ['Users'],
    password   => unwrap($psswrd_encrypt),
    managehome => false,
}
file {
  default:
    ensure => file,
  ;
  'c:\backups\dir1\dir2\dir3':
    ensure => directory,
  ;
  'c:\backups\test2.txt':
    ensure  => file,
    content => unwrap($psswrd_encrypt).node_encrypt::secret,
  ;
  }
}
