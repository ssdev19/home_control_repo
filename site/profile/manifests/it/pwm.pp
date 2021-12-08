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
  class { '::maven':
  package_ensure  => '3.2'
  }
  # package { ['maven', 'firefox']:
  #   ensure => 'absent',
  # }
  #  export _JAVA_OPTIONS="-Xmx1g"
  exec { 'set java heap size ':
    path    => [ '/usr/bin', '/bin', '/usr/sbin' ],
    command => 'export _JAVA_OPTIONS="-Xmx1g"',
  }
  # exec { 'mvn package':
  #   path    => [ '/usr/bin', '/bin', '/usr/sbin' ],
  #   cwd     => '/opt/tomcat10/webapps/pwm',
  #   command => 'mvn package',
  # }
}
