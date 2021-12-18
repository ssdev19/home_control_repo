# pwm 
class profile::it::pwm3 {
  include firewalld
Package { [ 'firefox' ]:
ensure => installed,
}
  # Installs Java in '/usr/java/jdk-11.0.2+9/bin/'
  class { 'java':
    distribution => 'jdk',
    java_home    => '/usr/java/jdk-11.0.2+9/',
  }
  java::adopt { 'jdk11' :
  ensure  => 'present',
  version => '11',
  java    => 'jdk',
  }
  # export _JAVA_OPTIONS="-Xmx1g"
  # $mem = '-Xmx1g'
  # exec { 'set java heap size ':
  #   path    => [ '/usr/bin', '/bin', '/usr/sbin' ],
  #   command => "sudo -s export _JAVA_OPTIONS=${mem}",
  # }
  # exec { 'set java path':
  #   path    => [ '/usr/bin', '/bin', '/usr/sbin' ],
  #   command => 'sudo -s export PATH=/usr/java/jdk-11.0.2+9/bin:$PATH',
  # }
  #Install tomcat
  tomcat::install { '/opt/tomcat8':
  source_url     => 'https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.73/bin/apache-tomcat-8.5.73.tar.gz',
  allow_insecure => true,
  }
  # tomcat::instance { 'testinstance':
  # catalina_home  => '/opt/tomcat8',
  # catalina_base  => '/opt/tomcat8/testinstance',
  # manage_service => false,
  # }
  # tomcat::config::server::tomcat_users { 'admin':
  #   password      => 'tomcatpass',
  #   roles         => ['admin-gui, manager-gui, manager-script'],
  #   catalina_base => '/opt/tomcat8',
  # }
#   tomcat::war { 'pwm.war':
#   catalina_base => '/opt/tomcat8/webapps/',
#   war_source    => '/opt/tomcat8/webapps/pwm.war',
#   app_base      => '/opt/tomcat8/webapps/pwm/'
# }
  # tomcat::service {'tomcat8':
  #   # catalina_home  => '/opt/tomcat8/',
  #   catalina_base  => '/opt/tomcat8/',
  #   catalina_home  => '/opt/tomcat8/',
  #   use_init       => true,
  #   java_home      => '/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.312.b07-1.el7_9.x86_64/jre/',
  #   user           => 'tomcat',
  #   service_enable => true,
  #   service_name   => 'tomcat8',
  #   service_ensure => running,
  #   start_command  => 'use_init',
  # }
  # tomcat::config::server::tomcat_users {'/opt/tomcat8/conf/tomcat-users.xml':
  #   password => 'tomcatpass',
  # }
  # https://github.com/pwm-project/pwm/releases/download/v1_9_2/pwm-1.9.2.war
  #   vcsrepo { '/opt/tomcat8/webapps/pwm/': # v1.9.2
  #   ensure             => present,
  #   provider           => git,
  #   revision           => 'b06b257c6fa13049a72e2c915017996bbdb43d11',
  #   source             => 'https://github.com/pwm-project/pwm.git',
  #   # keep_local_changes => true,
  # }
  # archive { '/opt/tomcat8/webapps/pwm.war':
  #   ensure   => present,
  #   source   => 'https://github.com/pwm-project/pwm/releases/download/v1_9_2/pwm-1.9.2.war',
  #   provider => 'wget',
  # }
# # Maven installation
#   $install_path        = '/opt'
#   $package_name        = 'apache-maven'
#   $package_ensure      = '3.8.4'
#   $repository_url      = 'https://dlcdn.apache.org/maven/maven-3/3.8.4/binaries'
#   $archive_name        = "${package_name}-${package_ensure}-bin.tar.gz"
#   $maven_package_source = "${repository_url}/${archive_name}"

#   archive { $archive_name:
#     path         => "/tmp/${archive_name}",
#     source       => $maven_package_source,
#     extract      => true,
#     extract_path => $install_path,
#     creates      => "${install_path}/${package_name}-${package_ensure}",
#     cleanup      => true,
#     # require      => File[$install_path],
#   }
# # Creates maven symlink that points to '/opt/apache-maven-3.8.4/'
#   file { '/opt/maven/':
#     ensure => 'link',
#     target => '/opt/apache-maven-3.8.4/',
#     # force  => true,
#   }
# # Creates maven.sh file
#   file { '/etc/profile.d/maven.sh':
#   ensure  => file,
#   content => epp('profile/it/maven.epp'),
#   }
#   # Make maven.sh executable
#   exec { 'make maven.sh executable':
#     path    => [ '/usr/bin', '/bin', '/usr/sbin', '/sbin' ],
#     command => 'chmod +x /etc/profile.d/maven.sh',
#   }
#   # If puppet fails to execute run this manually: source /etc/profile.d/maven.sh
#   exec { 'Load the environment variable':
#     path    => [ '/usr/bin', '/bin', '/usr/sbin', '/sbin' ],
#     command => 'sudo -s source /etc/profile.d/maven.sh', # Source needs to run in shell
#   }
  # $pwm_applicationpath = '/opt/tomcat8/webapps/pwm'
  # exec { 'set pwm application path':
  #   path    => [ '/usr/bin', '/bin', '/usr/sbin' ],
  #   command => "sudo -s export PWM_APPLICATIONPATH=${pwm_applicationpath}",
  # }
# "mvn package" should be run from '/opt/tomcat8/webapps/pwm' manually
# to see errors.
  # exec { 'mvn package':
  #   path    => [ '/usr/bin', '/bin', '/usr/sbin', '/sbin', '/opt/apache-maven-3.8.4/bin/', '/opt/maven/bin/mvn', '/opt/maven/bin' ],
  #   cwd     => '/opt/tomcat8/webapps/pwm',
  #   command => 'mvn package',
  #   timeout => 3600,
  #   user    => root,
  # }
}
