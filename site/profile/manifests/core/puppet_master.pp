class profile::core::puppet_master {
# package { 'toml':
#   ensure   => 'installed',
#   provider => 'puppetserver_gem',
# }
include node_encrypt::certificates
Puppet_authorization::Rule <| |> ~> Service['puppetserver Service']

  file{ '/root/README':
    ensure  => file,
    content => "Welcome to the ${fqdn},\n BIOS release date:${bios_release_date} \nthis is a Puppet Master Server\n
    This file is created because profile::core::puppet_master includes this class and in forpuppet_master role is set to puppet_master.",
  }
include r10k

# Encryption
# Puppet_authorization::Rule <| |> ~> Service['pe-puppetserver']

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
  }
}
