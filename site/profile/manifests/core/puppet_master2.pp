# foreman
class profile::core::puppet_master2 (Sensitive[String]
$psswrd_encrypt,
$pwd_encrypt,
){
  include foreman
  # include foreman::cli
  # include foreman::compute::libvirt
  # include foreman::compute::vmware
  # include foreman::plugin::remote_execution
  # include foreman::plugin::tasks
  include foreman_proxy
  # include foreman_proxy::plugin::dns::route53
  # include foreman_proxy::plugin::dynflow
  # include foreman_proxy::plugin::remote_execution::ssh
  # include node_exporter
  # include prometheus::node_exporter
  include prometheus::process_exporter
    package { 'toml':
    ensure   => present,
    provider => 'puppetserver_gem',
    }
# firewall config
  # class { 'firewalld':
  #   service_ensure => stopped,
  # }
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
# file {'/root/enctryp2':
#     ensure  => file,
#     owner   => 'root',
#     content => unwrap($psswrd_encrypt).node_encrypt::secret,
#   }
# ini_setting { "testfilecomment":
#   path => "/root/nagiostest.cfg",
#   section => 'test',
#   setting => 'cfg_file',
#   value => "/usr/local/nagios/etc/objects/${::hostname}.cfg"
# }
}
