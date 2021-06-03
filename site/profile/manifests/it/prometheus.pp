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
$gmail_auth_token = lookup('gmail_auth_token')
$gmail_account = lookup('gmail_account')
class { 'prometheus::alertmanager':
  version   => '0.22.2',
  global    => {
    'resolve_timeout' => '1m',
    },
  route     => {
    'group_by'        => ['alertname', 'cluster', 'service'],
    'group_wait'      => '30s',
    'group_interval'  => '5m',
    'repeat_interval' => '3h',
    'receiver'        => 'email',
  },
  receivers => [
    {
      'name'          => 'email',
      'email_configs' => [
        {
          'to'            => $gmail_account,
          'from'          => $gmail_account,
          'auth_username' => true,
          'auth_identity' => $gmail_account,
          'auth_password' => $gmail_auth_token,
          'send_resolved' => true,
        },
      ],
    },
  ],
}
}
