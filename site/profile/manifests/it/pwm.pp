# pwm 
class profile::it::pwm {
  java::adopt { 'jdk11' :
  ensure  => 'present',
  version => '11',
  java    => 'jdk',
  }
  tomcat::install { '/opt/tomcat10':
  source_url => 'https://archive.apache.org/dist/tomcat/tomcat-10/v10.0.4/bin/apache-tomcat-10.0.4.tar.gz'
  }
  package { 'maven':
    ensure => 'present',
  }
  exec { 'mvn package':
    path    => [ '/usr/bin', '/bin', '/usr/sbin' ],
    command => 'mvn package',
}
