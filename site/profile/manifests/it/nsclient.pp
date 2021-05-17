# nscliet
class profile::it::nsclient (Sensitive[String]
$nagios_password,
){
  class { 'nsclient':
    package_source_location => 'https://github.com/mickem/nscp/releases/download/0.3.7',
    package_name            => 'NSClient++ (x64)',
    package_source          => 'NSClient.-0.3.7-x64.msi',
    allowed_hosts           => ['140.252.32.34'],
    password                => unwrap($nagios_password),
    service_enable          => true,
  }
  service { 'NSClientpp':
  ensure => 'running',
}
}
