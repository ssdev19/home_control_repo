# nscliet
class profile::it::nsclient {
  class { 'nsclient':
    package_source_location => 'https://github.com/mickem/nscp/releases/download/0.3.7/',
    package_name            => 'NSClient++ (x64)',
    package_source          => '0.3.7.msi',
    allowed_hosts           => ['140.252.32.34'],
    password                => testpwd,
    service_enable          => true,
  }
}
