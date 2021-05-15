# Prometheus monitoring URL: http://prometheus.home.vm:9090/ 
class profile::it::prometheus {
  # include node_exporter
$target = "${::fqdn}:9100"
class { 'prometheus::node_exporter':
  version            => '0.12.0',
  collectors_disable => ['loadavg', 'mdadm'],
  extra_options      => '--collector.ntp.server ntp1.orange.intra',
}
class { 'prometheus::server':
  version        => '2.27.0',
  alerts         => {
    'groups' => [
      {
        'name'  => 'alert.rules',
        'rules' => [
          {
            'alert'       => 'InstanceDown',
            'expr'        => 'up == 0',
            'for'         => '5m',
            'labels'      => {
              'severity' => 'page',
            },
            'annotations' => {
              'summary'     => 'Instance {{ $labels.instance }} down',
              'description' => '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.'
            }
          },
        ],
      },
    ],
  },
  scrape_configs => [
    {
      'job_name'        => 'prometheus',
      'scrape_interval' => '10s',
      'scrape_timeout'  => '10s',
      'static_configs'  => [
        {
          'targets' => $target,
          'labels'  => {
            'alias' => 'Prometheus',
          }
        }
      ],
    },
  ],
}
}
