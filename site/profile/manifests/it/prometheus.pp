# Prometheus monitoring URL: http://prometheus.home.vm:9090/ 
class profile::it::prometheus {
  # include node_exporter
  include prometheus

user {'blackbox_exporter':
    ensure     => present,
    name       => 'blackbox_exporter',
    groups     => ['blackbox_exporter'],
    managehome => false,
}
archive { '/usr/tmp/blackbox_exporter-0.19.0.linux-amd64.tar.gz':
    ensure       => 'present',
    source       => 'https://github.com/prometheus/blackbox_exporter/releases/download/v0.19.0/blackbox_exporter-0.19.0.linux-amd64.tar.gz',
    extract      => true,
    extract_path => '/usr/tmp',
    cleanup      => true,
}
# file { '/usr/tmp/blackbox_exporter-0.19.0.linux-amd64/blackbox_exporter' :
#   ensure => present,
#   target => '/root/blackbox_exporter-0.19.0.linux-amd64/blackbox_exporter',
# }
}
