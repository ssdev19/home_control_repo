class profile::core::puppet_master {
package { 'toml':
  ensure   => 'installed',
  provider => 'puppetserver_gem',
}
  file{ '/root/README':
    ensure  => file,
    content => "Welcome to the ${fqdn},\n BIOS release date:${bios_release_date} \nthis is a Puppet Master Server\n
    This file is created because profile::core::foreman includes this class and in foreman role is set to foreman",
  }
include r10k

}
