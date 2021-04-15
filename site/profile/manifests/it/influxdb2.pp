class profile::it::influxdb2 {

  $openssl_country = lookup('country')
  $openssl_state = lookup('state')
  $openssl_locality = lookup('locality')
  $openssl_cn = $trusted['certname']

  $influx_admin_user = lookup('influx_admin_user')
  $influx_admin_passwd = lookup('influx_admin_passwd')

  $influx_grafana_user = lookup('influx_grafana_user')
  $influx_grafana_passwd = lookup('influx_grafana_passwd')

  $influx_telegraf_user = lookup('influx_telegraf_user')
  $influx_telegraf_passwd = lookup('influx_telegraf_passwd')
  $influx_telegraf_db_name = lookup('influx_telegraf_db_name')

# influxdb config file: /etc/influxdb/influxdb.conf
class { '::influxdb':
  admin_username => $influx_admin_user,
  admin_password => $influx_admin_passwd,
  configuration  => {
    'data'  => {
      'dir'                     => '/var/lib/influxdb/data',
      'wal-dir'                 => '/var/lib/influxdb/wal',
      'max-series-per-database' => 0,
      'max-values-per-tag'      => 0,
    },
    '[udp]' => {
      'enabled'       => true,
      'bind-address'  => ':8090',
      'database'      => 'metrics',
      'batch-pending' => 1024,
      'read-buffer'   => 33554432,
    },
  },
  databases      => {
    "${influx_telegraf_db_name}" => {
      'ensure' => present,
    }
  },
  users          => {
    # 'grafana'  => {
    #   'password' => $influx_grafana_passwd,
    #   privilege  => 'READ',
    #   database   => $influx_telegraf_db_name,
    # },
    'telegraf' => {
      'password'  => $influx_telegraf_passwd,
      'privilege' => 'READ',
      'database'  => $influx_telegraf_db_name,
    },
  },
}

influxdb::database { 'metrics': }

# influxdb::user { "${influx_grafana_user}":
#   password  => "${influx_grafana_passwd}",
#   privilege => 'READ',
#   database  => 'metrics',
# }

# Note: for durations, InfluxDB converts the duration literals to something else. Write that something else in puppet.
# influxdb::retention_policy { '1YearRetention':
#   database => "${influx_telegraf_db_name}",
#   duration => '8640h0m0s',
# }
}
