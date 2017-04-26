# puppet-nifi

Puppet manifest to install and configure Apache nifi

[![Build Status](https://secure.travis-ci.org/icalvete/puppet-nifi.png)](http://travis-ci.org/icalvete/puppet-nifi)

See [Nifi site](https://nifi.apache.org/)

## usage

```ruby
include nifi

nifi_pg {'test':
  ensure => present
}

nifi_template {'IN.hmStaff.taskStatus.xml':
  path   => 'https://your.domain.net/IN.hmStaff.taskStatus.xml',
  ensure => present
}
```

## Authors:

Israel Calvete Talavera <icalvete@gmail.com>
