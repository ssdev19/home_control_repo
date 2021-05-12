# foreman
class profile::core::puppet_master (Sensitive[String]
$psswrd_encrypt,
$pwd_encrypt,
){

  file{ '/root/README':
    ensure  => file,
    content => "\nWelcome to ${::fqdn},\nBIOS release date:${::bios_release_date} \nthis is a Puppet Master Server\n
  This file i s created because profile::core::puppet_master includes this class and in forpuppet_master role is set to puppet_master.\n",
  }

file {
  default:
    ensure => file,
    owner  => 'root',
    group  => 'root',
  ;
  '/etc/puppetlabs/puppet/eyaml':
    ensure => directory,
    mode   => '0755',
  ;
  '/root/encrypt':
    ensure  => file,
    mode    => '0755',
    content => unwrap($pwd_encrypt).node_encrypt::secret,
  ;
  }
# user {'erwin':
#     ensure     => present,
#     name       => 'erwin',
#     groups     => ['wheel'],
#     password   => pw_hash($pwd_encrypt.unwrap, 'SHA-512', 'mysalt'),
#     managehome => true,
# }
file {'/root/enctryp2':
    ensure  => file,
    owner   => 'root',
    content => unwrap($psswrd_encrypt).node_encrypt::secret,
  }
}
