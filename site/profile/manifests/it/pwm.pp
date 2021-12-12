# pwm 
class profile::it::pwm {
  include firewalld
  java::adopt { 'jdk11' :
  ensure  => 'present',
  version => '11',
  java    => 'jdk',
  }
  tomcat::install { '/opt/tomcat':
  source_url => 'https://archive.apache.org/dist/tomcat/tomcat-10/v10.0.4/bin/apache-tomcat-10.0.4.tar.gz'
  }
  tomcat::instance { 'default':
  catalina_home => '/opt/tomcat',
  }
    vcsrepo { '/opt/tomcat/webapps/pwm/':
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
  # exec { 'create symbolic link for maven':
  #   path    => [ '/usr/bin', '/bin', '/usr/sbin', '/sbin' ],
  #   command => 'sudo ln –s /opt/apache-maven-3.8.4 /opt/maven',
  #   onlyif  => 'test ! -f /opt/maven/README.txt'
  # }
  file { '/opt/maven/':
    ensure  => 'directory',
    source  => '/opt/apache-maven-3.8.4/',
    recurse => true,
    links   => follow,
  }
  # ->  file { '/opt/maven/':
  #       ensure => 'link',
  #       target => '/opt/maven/',
  #       force  => true,
  #     }
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
  # export _JAVA_OPTIONS="-Xmx1g"
  # exec { 'set java heap size ':
  #   path    => [ '/usr/bin', '/bin', '/usr/sbin' ],
  #   command => 'export _JAVA_OPTIONS="-Xmx1g"',
  # }
  # exec { 'mvn package':
  #   path    => [ '/opt/apache-maven-3.8.4/bin/', '/opt/maven/bin/mvn', '/opt/maven' ],
  #   cwd     => '/opt/tomcat10/webapps/pwm',
  #   command => '/opt/maven/bin/mvn package',
  # }
}
