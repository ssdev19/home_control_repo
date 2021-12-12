# pwm 
class profile::it::pwm {
  include firewalld
  # java::adopt { 'jdk11' :
  # ensure  => 'present',
  # version => '11',
  # java    => 'jdk',
  # }
  class { 'java' :
  package => 'java-1.8.0-openjdk-devel',
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
# Creates maven symlink
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
  # export _JAVA_OPTIONS="-Xmx1g"
  $mem = '-Xmx1g'
  exec { 'set java heap size ':
    path    => [ '/usr/bin', '/bin', '/usr/sbin' ],
    command => "sudo -s export _JAVA_OPTIONS=${mem}",
  }
  exec { 'mvn package':
    path    => [ '/opt/apache-maven-3.8.4/bin/', '/opt/maven/bin/mvn', '/opt/maven' ],
    cwd     => '/opt/tomcat/webapps/pwm',
    command => 'mvn package',
  }
}
