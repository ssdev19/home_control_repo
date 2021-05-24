# foreman
class profile::core::puppet_master (Sensitive[String]
$psswrd_encrypt,
$pwd_encrypt,
){
  include node_exporter

  class { 'firewalld':
    service_ensure => stopped,
  }
file {
  default:
    ensure => file,
    owner  => 'root',
    group  => 'root',
  ;
  '/root/README':
    ensure  => file,
    content => "\nWelcome to ${::fqdn},\nBIOS release date:${::bios_release_date} \nThis is The Puppet Master Server\n
  This file is created because profile::core::puppet_master includes this class and in forpuppet_master role is set to puppet_master.\n",
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
augeas { 'Append a 6nd line to /root/augeasfile':
  context => '/root/augeasfile',
  # Only if no node exists for http_proxy
  onlyif  => "match password/var[. = 'fakepwd'] size==0",
  changes => [
    # Create a new Defaults line for the two variables
    "ins Defaults after Defaults[last()]",
    # Make this Defaults line a += type
    "clear Defaults[last()]/env_keep/append",
    # assign values to the two variables
    "set Defaults[last()]/env_keep/var[1] http_proxy",
    "set Defaults[last()]/env_keep/var[2] https_proxy",
  ],
}
}
