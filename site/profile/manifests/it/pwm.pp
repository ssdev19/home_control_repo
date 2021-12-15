# pwm 
class profile::it::pwm {
  include firewalld
Package { [ 'firefox' ]:
ensure => installed,
}
  # Installs Java in '/usr/java/jdk-11.0.2+9/bin/'
  class { 'java':
    distribution => 'jdk',
  }
  java::adopt { 'jdk11' :
  ensure  => 'present',
  version => '11',
  java    => 'jdk',
  }
  # export _JAVA_OPTIONS="-Xmx1g"
  $mem = '-Xmx1g'
  exec { 'set java heap size ':
    path    => [ '/usr/bin', '/bin', '/usr/sbin' ],
    command => "sudo -s export _JAVA_OPTIONS=${mem}",
  }
  #Install tomcat
  tomcat::install { '/opt/tomcat9':
  source_url => 'https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.56/bin/apache-tomcat-9.0.56.tar.gz'
  }
  tomcat::instance { 'default':
  catalina_home  => '/opt/tomcat9',
  # manage_service => false,
  }
  tomcat::war { 'pwm.war':
  catalina_base => '/opt/tomcat9/pwm',
  war_source    => '/opt/tomcat9/webapps/pwm.war',
}
  # tomcat::service {'tomcat service':
  #   catalina_home  => '/opt/tomcat9/',
  #   # catalina_base => '/opt/tomcat9/',
  #   use_init       => true,
  #   service_enable => true,
  #   service_name   => 'tomcat',
  #   # start_command  => 'use_init'
  # }
  # tomcat::config::server::tomcat_users {'/opt/tomcat9/conf/tomcat-users.xml':
  #   password => 'tomcatpass',
  # }
  # https://github.com/pwm-project/pwm/releases/download/v1_9_2/pwm-1.9.2.war
  #   vcsrepo { '/opt/tomcat9/webapps/pwm/': # v1.9.2
  #   ensure             => present,
  #   provider           => git,
  #   revision           => 'b06b257c6fa13049a72e2c915017996bbdb43d11',
  #   source             => 'https://github.com/pwm-project/pwm.git',
  #   # keep_local_changes => true,
  # }
  archive { '/opt/tomcat9/webapps/pwm.war':
    ensure   => present,
    source   => 'https://github.com/pwm-project/pwm/releases/download/v1_9_2/pwm-1.9.2.war',
    provider => 'wget',
  }
# Maven installation
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
# Creates maven symlink that points to '/opt/apache-maven-3.8.4/'
  file { '/opt/maven/':
    ensure => 'link',
    target => '/opt/apache-maven-3.8.4/',
    # force  => true,
  }
# Creates maven.sh file
  file { '/etc/profile.d/maven.sh':
  ensure  => file,
  content => epp('profile/it/maven.epp'),
  }
  # Make maven.sh executable
  exec { 'make maven.sh executable':
    path    => [ '/usr/bin', '/bin', '/usr/sbin', '/sbin' ],
    command => 'chmod +x /etc/profile.d/maven.sh',
  }
  # If puppet fails to execute run this manually: source /etc/profile.d/maven.sh
  exec { 'Load the environment variable':
    path    => [ '/usr/bin', '/bin', '/usr/sbin', '/sbin' ],
    command => 'sudo -s source /etc/profile.d/maven.sh', # Source needs to run in shell
  }
# "mvn package" should be run from '/opt/tomcat9/webapps/pwm' manually
# Having puppet execute, times out.
  # exec { 'mvn package':
  #   path    => [ '/usr/bin', '/bin', '/usr/sbin', '/sbin', '/opt/apache-maven-3.8.4/bin/', '/opt/maven/bin/mvn', '/opt/maven/bin' ],
  #   cwd     => '/opt/tomcat9/webapps/pwm',
  #   command => 'mvn package',
  #   user    => root
  # }
}
