class profile::core::puppet_master {
  file{ '/root/README':
    ensure  => file,
    content => "Welcome to the ${fqdn},\n BIOS release date:${bios_release_date} \nthis is a Puppet Master Server\n
    This file is created becaus in foreman role is set to forman",
  }
include r10k
}
