# pwm 
class profile::it::pwm {
  include firewalld
  java::adopt { 'jdk11' :
  ensure  => 'present',
  version => '11',
  java    => 'jdk',
  }
  tomcat::install { '/opt/tomcat10':
  source_url => 'https://archive.apache.org/dist/tomcat/tomcat-10/v10.0.4/bin/apache-tomcat-10.0.4.tar.gz'
  }
  tomcat::instance { 'default':
  catalina_home => '/opt/tomcat10',
  }
    vcsrepo { '/opt/tomcat10/webapps/pwm/':
    ensure             => present,
    provider           => git,
    revision           => 'b06b257c6fa13049a72e2c915017996bbdb43d11',
    source             => 'https://github.com/pwm-project/pwm.git',
    # keep_local_changes => true,
  }

# archive { '/tmp/apache-maven-3.8.4-src.tar.gz':
#   ensure        => present,
#   extract       => true,
#   extract_path  => '/tmp',
#   source        => 'http://apache.rediris.es/maven/maven-3/3.8.4/source/apache-maven-3.8.4-src.tar.gz',
#   creates       => '/opt/maven',
#   cleanup       => true,
# }

$install_path        = '/opt'
$package_name        = 'apache-maven'
$package_ensure      = '3.8.4'
$repository_url      = 'https://dlcdn.apache.org/maven/maven-3/3.8.4/binaries'
$archive_name        = "${package_name}-${package_ensure}-bin.tar.gz"
$maven_package_source = "${repository_url}/${archive_name}"

archive { $archive_name:
  path         => "/tmp/${archive_name}",
  source       => $maven_package_source,
  extract      => true,
  extract_path => $install_path,
  creates      => "${install_path}/${package_name}-${package_ensure}",
  cleanup      => true,
  # require      => File[$install_path],
}
  file { '/etc/profile.d/maven.sh':
  ensure  => file,
  content => epp('profile/it/maven.epp'),
  }
  # Make maven.sh executable
  exec { 'make maven.sh executable':
    path    => [ '/usr/bin', '/bin', '/usr/sbin', '/sbin' ],
    command => 'chmod +x /etc/profile.d/maven.sh',
  }
  exec { 'Load the environment variable':
    path    => [ '/usr/bin', '/bin', '/usr/sbin', '/sbin' ],
    command => 'sudo -s source /etc/profile.d/maven.sh', # Source needs to run in shell
  }
  #  export _JAVA_OPTIONS="-Xmx1g"
  # exec { 'set java heap size ':
  #   path    => [ '/usr/bin', '/bin', '/usr/sbin' ],
  #   command => 'export _JAVA_OPTIONS="-Xmx1g"',
  # }
  # exec { 'mvn package':
  #   path    => [ '/usr/bin', '/bin', '/usr/sbin' ],
  #   cwd     => '/opt/tomcat10/webapps/pwm',
  #   command => 'mvn package',
  # }
}
