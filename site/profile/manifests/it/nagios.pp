# nagios
class profile::it::nagios {
  # include ::nrpe
  class { '::nrpe':
  package_ensure => latest,
  service_manage => false,
}
  # Install Nagios server
  # class { 'nagios':
  #   nrpe        => true,                     # Set up NRPE for monitoring of remote hosts
  #   nsca        => false,                    # Skip NSCA, which is needed for passive checks
  #   selinux     => true,                     # Manage SELinux policies to allow Nagios to run smoothly
  #   firewall    => true,                     # Manage firewall rules to allow Nagios/NRPE to run smoothly
  #   url         => 'nagios.home.vm',     # Service URL of Nagios, if different from the system hostname
  #   serveradmin => 'root@home.vm',       # Admin's email address
  #   ssl_cert    => '/etc/pki/tls/certs/nagios.home.vm.pem',  # Path to SSL cert for HTTPS
  #   ssl_key     => '/etc/pki/tls/private/nagios.home.vm.key',  # Path to SSL key for HTTPS
  #   auth_type   => 'CAS',                    # Override Apache basic auth and use CAS single sign-on instead
  # }

  # Deploy HTTPS certificate
  # file { '/etc/pki/tls/certs/nagios.example.com.pem':
  #   source => 'puppet:///modules/profile/nagios/nagios.example.com.pem',
  #   mode   => '0644',
  #   owner  => 'root',
  #   group  => 'root',
  # }

  # # Deploy HTTPS private key
  # file { '/etc/pki/tls/private/nagios.home.vm.key':
  #   source => 'puppet:///modules/profile/nagios/nagios.home.vm.key',
  #   mode   => '0600',
  #   owner  => 'root',
  #   group  => 'root',
  # }
}
