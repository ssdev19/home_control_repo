# nagios
class profile::it::nagios (
$content,
$servicecontent,
) {
  # include ::nrpe

user {'blackbox_exporter':
    ensure     => present,
    name       => 'blackbox_exporter',
    # groups     => ['blackbox_exporter'],
    managehome => false,
}
archive { '/usr/tmp/blackbox_exporter-0.19.0.linux-amd64.tar.gz':
    ensure       => 'present',
    source       => 'https://github.com/prometheus/blackbox_exporter/releases/download/v0.19.0/blackbox_exporter-0.19.0.linux-amd64.tar.gz',
    extract      => true,
    extract_path => '/usr/tmp',
    cleanup      => true,
}
$source_directory = '/usr/tmp/blackbox_exporter-0.19.0.linux-amd64/blackbox_exporter'
$target_directory = '/usr/local/bin/blackbox_exporter'
file { $target_directory :
  owner  => 'blackbox_exporter',
  source => 'file:///usr/tmp/blackbox_exporter-0.19.0.linux-amd64/blackbox_exporter',
}
file { '/etc/blackbox_exporter':
  ensure => directory,
  owner  => 'blackbox_exporter',
}
file { '/etc/blackbox_exporter/blackbox.yml':
  ensure  => file,
  owner   => 'blackbox_exporter',
  content => $content,
  }
file { '/etc/systemd/system/blackbox_exporter.service':
  ensure  => file,
  content => $servicecontent,
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
