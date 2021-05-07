class profile::it::nxlog {
  class {'nxlog':
  conf_dir       => 'D:/Program Files (x86)/nxlog/conf', # note the /'s here
  conf_file      => 'nxlog.conf',
  ensure_setting => latest,
  nxlog_root     => 'D:\\Program Files (x86)\\nxlog',
  }
  nxlog::config::extension { 'gelf':
  ext_module => 'xm_gelf',
}

nxlog::config::input { 'eventlog_gelf':
  input_module => 'im_mseventlog',
}

nxlog::config::output { 'om_udp':
  output_file_path => 'D:\\Program Files (x86)\\nxlog\\dataeventlog-gelf.txt',
  output_module    => 'om_file',
}

nxlog::config::output { 'logserver':
  output_address => '192.168.0.48',
  output_module  => 'om_udp',
  output_port    => '6514',
}

# nxlog::config::route { 'local':
#   route_destination => [ 'local_json', ],
#   route_source      => [ 'eventlog_json', ],
# }

nxlog::config::route { '1':
  route_destination => [ 'logserver', ],
  route_source      => [ 'eventlog_gelf', ],
}
}
