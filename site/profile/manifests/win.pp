# For windows computers
class profile::win (Sensitive
$psswrd,
$secretcontent,
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
file { 'c:\backups':
  ensure  => directory,
}
file { 'c:\backups\encrypted.txt':
  ensure  => file,
  content => unwrap($secretcontent)
}
file { 'c:\backups\fact.txt':
  ensure  => file,
  content => template('profile/it/testfact.erb')
}
user {'bob':
    ensure     => absent,
    name       => 'bob',
    groups     => ['Users'],
    password   => unwrap($psswrd),
    managehome => false,
}
}
