class profile::core::puppet_master {
# package { 'toml':
#   ensure   => 'installed',
#   provider => 'puppetserver_gem',
# }
  file{ '/root/README':
    ensure  => file,
    content => "Welcome to the ${fqdn},\n BIOS release date:${bios_release_date} \nthis is a Puppet Master Server\n
    This file is created because profile::core::puppet_master includes this class and in forpuppet_master role is set to puppet_master",
  }
include r10k

# Encryption


# Puppet_authorization::Rule <| |> ~> Service['puppetserver']

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
  # '/etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem':
  #   group   => 'puppet',
  #   mode    => '0440',
  #   content => lookup('profile::pe::master::eyaml_private_key'),
  # ;
  # '/etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem':
  #   mode   => '0444',
  #   source => 'puppet:///modules/profile/pe/master/eyaml_public_key.pkcs7.pem',
  # ;
}

package { 'hiera-eyaml puppetserver_gem':
  ensure   => '2.7.6',
  name     => 'hiera-eyaml',
  provider => 'puppetserver_gem',
  notify   => Service['puppetserver'],
}
}
