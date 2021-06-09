# Network configuration
class profile::it::network (Sensitive[String]
$ip_hide,
$mask_hide,
){
include '::network'
  network_config { 'eth0':
  ensure    => 'present',
  family    => 'inet',
  ipaddress => unwrap($ip_hide),
  method    => 'static',
  netmask   => unwrap($mask_hide),
  onboot    => 'true',
  hotplug   => 'true',
  options   => {'pre-up' => 'sleep 2'},
}
}
