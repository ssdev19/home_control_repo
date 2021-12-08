# pwm 
class profile::it::pwm {
  class { 'java' :
  package => 'java-1.8.0-openjdk-devel',
  }
  tomcat::install { '/opt/tomcat10':
  source_url => 'https://archive.apache.org/dist/tomcat/tomcat-10/v10.0.4/bin/apache-tomcat-10.0.4.tar.gz'
  }

}
