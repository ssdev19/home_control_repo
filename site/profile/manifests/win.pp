# For windows computers
class profile::win (Sensitive
$psswrd_encrypt,
$secretcontent_encrypt,
) {
  include chocolatey
  include facter
facter::fact { 'symantec_defenition_version':
  value => 'test',
}
##### Note: This process could take over 20 minutes so be patient. #####
class {'::puppet_agent':
  package_version => '7.6.1',
  source          => 'https://downloads.puppetlabs.com/windows/puppet7/puppet-agent-7.6.1-x64.msi'
}
class { 'nsclient':
  allowed_hosts => ['192.168.0.0/24','192.168.1.0/24'],
}

package { 'nxlog':
  ensure   => present,
  provider => chocolatey,
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
  'c:\backups':
    ensure => directory,
  ;
  'c:\backups\test2.txt':
    ensure  => file,
    content => unwrap($psswrd_encrypt).node_encrypt::secret,
  ;
  }
}
