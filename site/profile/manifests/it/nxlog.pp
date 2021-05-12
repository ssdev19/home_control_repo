# Nxlog
class profile::it::nxlog (Sensitive[String]
$graylogip_hide,
$graylogport_hide,
){
    # package { 'NXLog-CE':
    #     ensure => '2.10.2150',
    #     source => 'https://nxlog.co/system/files/products/files/348/nxlog-ce-2.10.2150.msi'
    # }
class {'nxlog':
  conf_dir       => 'C:/Program Files (x86)/nxlog/conf', # note the /'s here
  conf_file      => 'nxlog.conf',
  ensure_setting => latest,
  nxlog_root     => 'C:\Program Files (x86)\nxlog',
}
nxlog::config::extension { 'gelf':
  ext_module => 'xm_gelf',
}

nxlog::config::input { 'eventlog_gelf':
  input_module  => 'im_mseventlog',
}

# nxlog::config::input { 'eventlog_gelf_2':
#   input_module => 'im_msvistalog',
# }

nxlog::config::output { 'om_udp':
  output_file_path => 'C:\Program Files (x86)\nxlog\data\nxlog.log',
  output_module    => 'om_file',
}

nxlog::config::output { 'aws_graylog':
  output_address => unwrap($graylogip_hide),
  output_module  => 'om_udp',
  output_port    => unwrap($graylogport_hide),
}

nxlog::config::route { '1':
  route_destination => [ 'aws_graylog', ],
  route_source      => [ 'eventlog_gelf', ],
}

# nxlog::config::route { '2':
#   route_destination => [ 'aws_graylog', ],
#   route_source      => [ 'eventlog_gelf_2', ],
# }
}
