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
}
