# Prometheus monitoring URL: http://prometheus.home.vm:9090/ 
class profile::it::prometheus (
$content,
) {
  # include node_exporter
  include prometheus
  # include prometheus::blackbox_exporter
  class { 'prometheus::blackbox_exporter':
    version => '0.19.0',
    modules => {
      'http_2xx' => {
        'prober'  => 'http',
        'timeout' => '5s',
        'http'    => {
          'valid_status_codes' => [],
          'method'             => 'GET',
        }
      }
    }
  }
# user {'blackbox_exporter':
#     ensure     => present,
#     name       => 'blackbox_exporter',
#     groups     => ['blackbox_exporter'],
#     managehome => false,
# }
# archive { '/usr/tmp/blackbox_exporter-0.19.0.linux-amd64.tar.gz':
#     ensure       => 'present',
#     source       => 'https://github.com/prometheus/blackbox_exporter/releases/download/v0.19.0/blackbox_exporter-0.19.0.linux-amd64.tar.gz',
#     extract      => true,
#     extract_path => '/usr/tmp',
#     cleanup      => true,
# }
# file { '/usr/tmp/blackbox_exporter-0.19.0.linux-amd64/blackbox_exporter' :
#   ensure => present,
#   target => '/root/blackbox_exporter-0.19.0.linux-amd64/blackbox_exporter',
# }
}
