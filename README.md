# puppet-nifi

Puppet manifest to install and configure Apache nifi

[![Build Status](https://secure.travis-ci.org/icalvete/puppet-nifi.png)](http://travis-ci.org/icalvete/puppet-nifi)

See [Nifi site](https://nifi.apache.org/)

## usage

```puppet
include nifi

nifi_pg {'test':
  ensure => present
}

nifi_template {'IN.hmStaff.taskStatus.xml':
  path   => 'https://your.domain.net/IN.hmStaff.taskStatus.xml',
  ensure => present
}

nifi_template {'IN.hmClients.taskStatus.xml':
  path   => '/opt/nifi/templetes/IN.hmClients.taskStatus.xml',
  ensure => present
}
```

### Modifying a template

* Modify your source template ( **Be careful with ID attributes. Some changes there could break the template** )
* "Repuppet" the machine again. (*puppet agent* ... or *puppet apply* ...)

### Auth by client certificates

* Generate your user certificate
* Generate your keystore
* Generate your truststore with and add your user

You can do this by hand using [this guide](https://www.batchiq.com/nifi-configuring-ssl-auth.html) or you can use [nifi tool](https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html#tls-generation-toolkit)

At the end you must have:

* A keystore file (keystore.jks)
* A Keystore password
* A Truststore file (truststore.jks)
* A Truststore password
* A User certificate (P12 and PEM)

To transfoem P12 to PEM...

```
openssl pkcs12 -in  CN=admin_DC=nifi_DC=com.p12 -passin pass:26V+Hs1qupglToDlVqO+oKW0yWR2jG3uXjuFTUus76o -out CN=admin_DC=nifi_DC=com.pem
```

Final steps:

Add your User certificate to your browser. ( Described [here](https://www.batchiq.com/nifi-configuring-ssl-auth.html) or you can use [nifi tool](https://nifi.apache.or    g/docs/nifi-docs/html/administration-guide.html#tls-generation-toolkit)) )

Change your node definition.

```puppet
class {'nifi':
  auth                   => 'cert',
  keystore_file_source   => 'https://ec2-33-238-128-156.eu-west-1.compute.amazonaws.com/keystore.jks',
  keystore_password      => 'E+1QhIPIa4t4yeKbsNP9UygyexN6LBXPj0Ng/gMlbJU',
  truststore_file_source => 'https://ec2-33-238-128-156.eu-west-1.compute.amazonaws.com/truststore.jks',
  truststore_password    => 'cptQV3vpgae/yMZZ2JcP5N35E6pL0zXUz5m390fUaQU',
  admin_name             => 'CN=admin, DC=nifi, DC=com',
  admin_cert             => 'CN=admin_DC=nifi_DC=com.pem'
}

nifi_pg {'test':
  ensure => present
}

nifi_template {'IN.hmStaff.taskStatus.xml':
  path   => 'https://your.domain.net/IN.hmStaff.taskStatus.xml',
  ensure => present
}

nifi_template {'IN.hmClients.taskStatus.xml':
  path   => '/opt/nifi/templetes/IN.hmClients.taskStatus.xml',
  ensure => present
}
```

After a "repuppet", you can access your nifi server https://<nifi_ip>:9443/nifi

## Authors:

Israel Calvete Talavera <icalvete@gmail.com>
