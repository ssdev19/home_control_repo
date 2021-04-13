class profile::it::influxdb {

# create certs for http
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
#include influxdb

  exec{'Create Selfsigned cert':
    path    => '/usr/bin/',
    command => "openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/ssl/influxdb.key -out /etc/ssl/influxdb.crt -days 365 -subj \"/C=${openssl_country}/ST=${openssl_state}/L=${openssl_locality}/O=LSST/CN=${openssl_cn}\"",
    onlyif  => 'test ! -f /etc/ssl/influxdb.crt'
    }
# influxdb config file: /etc/influxdb/influxdb.conf
  class {'influxdb':
    # version                        => '2.0',
    admin_password                 => $influx_admin_passwd,
#    admin_user                     => $influx_admin_user,
    service_ensure                 => running,
    http_enabled                   => true,
# #    write_tracing               => false,
#    auth_enabled                   => true,
# #    log_enabled                 => true,
# #    suppress-write-log          => false,
#    pprof_enabled                  => true,
# #    bind_address                   => ':8088',
#     # meta_http_bind_address => ":8091",
#     bind_address                   => ':8086',
#     # influxd_opts           => lookup('influxdb_opts'),
    http_https_certificate_path    => '/etc/ssl/influxdb.crt',
    http_https_certificate_content => lookup('https_certificate_content'),
    http_https_private_key_path    => '/etc/ssl/influxdb.key',
    http_https_private_key_content => lookup('https_private_key_content'),
    # http_https_enabled             => true,
#     # auth_superuser              => lookup($influx_admin_user),
#     # auth_superpass              => lookup($influx_admin_passwd),
#   #  admin_username                 => $influx_admin_user,
}



# influx_username{$influx_admin_user:
#     ensure   => present,
#     password => $influx_admin_passwd,
#     database => $influx_telegraf_db_name,
# }
# influx_database{$influx_telegraf_db_name:
#   ensure    => present,
#   superuser => $influx_telegraf_user,
#   superpass => $influx_telegraf_passwd,
# }

  firewalld_port { 'InfluxDB Main Port':
    ensure   => present,
    port     => '8086',
    protocol => 'tcp',
    require  => Service['firewalld'],
  }

  firewalld_port { 'InfluxDB Internodes Port':
    ensure   => present,
    port     => '8091',
    protocol => 'tcp',
    require  => Service['firewalld'],
  }

  package{'net-snmp':
    ensure => 'installed'
  }

  package{'net-snmp-utils':
    ensure => 'installed'
  }

# exec { "create_database_${$influx_telegraf_db_name}":
#       path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
#       command => "influx -ssl -unsafeSsl -username '${influx_admin_user}' -password '${influx_admin_passwd}' -execute \"CREATE DATABASE ${influx_telegraf_db_name}\"",
#       onlyif  => "test $(influx -ssl -unsafeSsl -execute 'show databases' -username '${influx_admin_user}' -password '${influx_admin_passwd}' &> /dev/null; echo $? ) -eq 1",
#       require => Class['influxdb']
#     }


  # exec{'Create admin user on influxdb':
  #   path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
  #   command => "influx -ssl -unsafeSsl -execute \"CREATE USER ${influx_admin_user} WITH PASSWORD '${influx_admin_passwd}' WITH ALL PRIVILEGES\"",
  #   onlyif  => "test $(influx -ssl -unsafeSsl -execute 'show databases' -username '${influx_admin_user}' -password '${influx_admin_passwd}' &> /dev/null; echo $? ) -eq 1"
  # }



	# exec{"Create admin user on influxdb":
	# 	path    => ['/usr/bin','/usr/sbin'],
	# 	command => "influx -ssl -unsafeSsl -execute \"CREATE USER ${influx_admin_user} WITH PASSWORD '${influx_admin_passwd}' WITH ALL PRIVILEGES\"",
	# 	onlyif => "test $(influx -ssl -unsafeSsl -execute 'show databases' -username '${influx_admin_user}' -password '${influx_admin_passwd}' &> /dev/null; echo $? ) -eq 1"
	# }


	# exec{"Create telegraf database on influxdb":
	# 	path    => ['/usr/bin','/usr/sbin'],
	# 	command => "influx -ssl -unsafeSsl -username '${influx_admin_user}' -password '${influx_admin_passwd}' -execute \"CREATE DATABASE ${influx_telegraf_db_name}\"",
	# 	require => Exec["Create admin user on influxdb"],
	# 	onlyif => "test $(influx -ssl -unsafeSsl -username '${influx_admin_user}' -password '${influx_admin_passwd}' -execute \"SHOW DATABASES\" | grep ${influx_telegraf_db_name} | wc -l ) -lt 1"
	# }


	# exec{"Create telegraf user on influxdb":
	# 	path    => ['/usr/bin','/usr/sbin'],
	# 	command => "influx -ssl -unsafeSsl -username '${influx_admin_user}' -password '${influx_admin_passwd}' -execute \"CREATE USER ${influx_telegraf_user} WITH PASSWORD '${influx_telegraf_passwd}'\"",
	# 	require => [Exec["Create admin user on influxdb"],Exec["Create telegraf database on influxdb"]],
	# 	onlyif => "test $(influx -ssl -unsafeSsl -username '${influx_admin_user}' -password '${influx_admin_passwd}' -execute \"SHOW USERS\" | grep ${influx_telegraf_user} | wc -l ) -lt 1",
	# }

	# exec{"Grant WRITE access to telegraf db influxdb":
	# 	path    => ['/usr/bin','/usr/sbin'],
	# 	command => "influx -ssl -unsafeSsl  -username '${influx_admin_user}' -password '${influx_admin_passwd}' -execute \"GRANT WRITE ON ${influx_telegraf_db_name} TO ${influx_telegraf_user}\"",
	# 	require => [Exec["Create admin user on influxdb"],Exec["Create telegraf database on influxdb"], Exec["Create telegraf user on influxdb"]],
	# 	onlyif => "test $(influx -ssl -unsafeSsl -username '${influx_admin_user}' -password '${influx_admin_passwd}' -execute \"SHOW GRANTS FOR ${influx_telegraf_user}\" | grep -i ${influx_telegraf_db_name} | grep -i WRITE | wc -l ) -lt 1",
	# }

	
	# exec{"Create grafana user on influxdb":
	# 	path    => ['/usr/bin','/usr/sbin'],
	# 	command => "influx -ssl -unsafeSsl -username '${influx_admin_user}' -password '${influx_admin_passwd}' -execute \"CREATE USER ${influx_grafana_user} WITH PASSWORD '${influx_grafana_passwd}'\"",
	# 	require => [Exec["Create admin user on influxdb"],Exec["Create telegraf database on influxdb"]],
	# 	onlyif => "test $(influx -ssl -unsafeSsl -username '${influx_admin_user}' -password '${influx_admin_passwd}' -execute \"SHOW USERS\" | grep ${influx_grafana_user} | wc -l ) -lt 1",
	# }

	# exec{"Grant READ access to telegraf db influxdb":
	# 	path    => ['/usr/bin','/usr/sbin'],
	# 	command => "influx -ssl -unsafeSsl -username '${influx_admin_user}' -password '${influx_admin_passwd}' -execute \"GRANT READ ON ${influx_telegraf_db_name} TO ${influx_grafana_user}\"",
	# 	require => [Exec["Create admin user on influxdb"],Exec["Create telegraf database on influxdb"], Exec["Create grafana user on influxdb"]],
	# 	onlyif => "test $(influx -ssl -unsafeSsl -username '${influx_admin_user}' -password '${influx_admin_passwd}' -execute \"SHOW GRANTS FOR ${influx_grafana_user}\" | grep -i ${influx_telegraf_db_name} | grep -i READ | wc -l ) -lt 1",
	# }
	# define the telegraf plugins to be used on influx for network monitoring
}
