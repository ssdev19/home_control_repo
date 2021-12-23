# pwm 
class profile::it::pwm2 {
  # include firewalld
  archive { '/tmp/pwm.war':
    ensure   => present,
    source   => 'https://github.com/pwm-project/pwm/releases/download/v1_9_2/pwm-1.9.2.war',
    provider => 'wget',
    cleanup  => false,
  }
  ########################
  # open file /opt/tomcat/webapps/pwm/WEB-INF/web.xml
  # Set ApplicationPath to /opt/tomcat/webapps/pwm/WEB-INF
  ########################
  $applicationpath = lookup('application_path')
  $webpath = lookup('web_path')
  file { '/opt/tomcat/webapps/pwm/WEB-INF/web.xml':
    ensure => present,
  }
  -> file_line { 'Append a line to pwm/WEB-INF/web.xml':
      path  => $webpath,
      line  => "<param-value>${applicationpath}</param-value>",
      match => '<param-value>unspecified</param-value>', # "^unspecified.*$" can be used for string
    }
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

# "mvn package" should be run from '/opt/tomcat/webapps/pwm' manually
# to see errors.
  # exec { 'mvn package':
  #   path    => [ '/usr/bin', '/bin', '/usr/sbin', '/sbin', '/opt/apache-maven-3.8.4/bin/', '/opt/maven/bin/mvn', '/opt/maven/bin' ],
  #   cwd     => '/opt/tomcat/webapps/pwm',
  #   command => 'mvn package',
  #   timeout => 3600,
  #   user    => root,
  # }
}
