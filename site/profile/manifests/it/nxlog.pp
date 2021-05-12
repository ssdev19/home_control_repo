# Nxlog
class profile::it::nxlog {
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
  input_module2 => 'im_msvistalog',
}

# nxlog::config::input { 'eventlog_gelf':
#   input_module => 'im_msvistalog',
# }

nxlog::config::output { 'om_udp':
  output_file_path => 'C:\\Program Files (x86)\\nxlog\\data\\dataeventlog-gelf.txt',
  output_module    => 'om_file',
}

nxlog::config::output { 'logserver':
  output_address => '192.168.0.48',
  output_module  => 'om_udp',
  output_port    => '6514',
}

nxlog::config::route { 'local':
  route_destination => [ 'local_json', ],
  route_source      => [ 'eventlog_json', ],
}

nxlog::config::route { '1':
  route_destination => [ 'logserver', ],
  route_source      => [ 'eventlog_gelf', ],
}
}
