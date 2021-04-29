class profile::win {
  include chocolatey
#  include 'nsclient'
class { 'nsclient':
  allowed_hosts => ['10.21.0.0/22','10.21.4.0/22'],
}
file { 'c:\backups':
  ensure  => directory,
}
user {'bob':
    ensure     => present,
    name       => 'bob',
    groups     => ['Users'],
    password   => 'ENC[PKCS7,MIIBeQYJKoZIhvcNAQcDoIIBajCCAWYCAQAxggEhMIIBHQIBAD
  AFMAACAQEwDQYJKoZIhvcNAQEBBQAEggEAaVSoJtkJDPTjQMfMPBPKg50SkS
  GmfZuo7B0cIod+OT+HZagEhIHmdVOOzKAhEK/5+mD3/t5526BcCc/HwcKcE6
  Ss3MaR5eEyNF5s23b7CdEQ8v1xdfvpoC6FXaJ4Ltyu1EOWobeXK5NTydxMwC
  PMqZccEBSYawBtFQ8XG9RcCxpehFPxizsH+0s4V2itpk9OKHXUWI+9JFmhTd
  oWndWltAPfU7ZpYn/zxGJkLed+gmnkJSoN24XQAHqeyUqtCYInVGVdkLe0GC
  JGhcTmlJNQF0kW4+LaCN4rBxgR0LSQuISjSpkP141WGcLSu0a/xCLrI46Lbu
  r3qccfFrTViZ1fozA8BgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBB8NKfV2j
  +BKnt6HffK1eUugBB63iPQqSVKHBOsORm9WjTJ]',
    managehome => false,
}
}
