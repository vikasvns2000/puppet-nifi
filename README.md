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

Example


#### Create server certificates.
```
root@doc# openssl req -x509 -newkey rsa:2048 -keyout admin-private-key.pem -out admin-cert.pem -days 365 -subj "/CN=admin/DC=nifi/DC=com" -nodes
Generating a 2048 bit RSA private key
...............................................................+++
.....................+++
writing new private key to 'admin-private-key.pem'
-----
```

#### Create User certificate.
```
root@doc# openssl pkcs12 -inkey admin-private-key.pem -in admin-cert.pem -export -out admin-q-user.pfx -passout pass:"SecretUser"
```

#### Create keystore.
```
root@doc# keytool -genkeypair -alias nifiserver -keyalg RSA -keypass SecretServer -storepass SecretServer -keystore keystore.jks -dname "CN=Test NiFi Server" -noprompt
```

#### Create truststore.
```
root@doc# keytool -importcert -v -trustcacerts -alias admin -file admin-cert.pem -keystore truststore.jks -storepass SecretServer -noprompt
```

At the end you must have:

* A keystore file (keystore.jks)
* A Keystore password
* A Truststore file (truststore.jks)
* A Truststore password
* A User certificate (P12)

Final steps:

Add your User certificate to your browser. ( Described [here](https://www.batchiq.com/nifi-configuring-ssl-auth.html))

You can use [nifi tool](https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html#tls-generation-toolkit) to manage certs. 

Change your node definition.

```puppet
class {'nifi':
  auth                   => 'cert',
  keystore_file_source   => 'https://ec2-33-238-128-156.eu-west-1.compute.amazonaws.com/keystore.jks',
  keystore_password      => 'SecretServer'
  truststore_file_source => 'https://ec2-33-238-128-156.eu-west-1.compute.amazonaws.com/truststore.jks',
  truststore_password    => 'SecretServer',
  admin                  => 'CN=admin, DC=nifi, DC=com'
}

class {'nifi':
  auth                   => 'cert',
  keystore_file_source   => 'file:///vagrant/data/nifi/keystore.jks', # or https://ec2-33-238-128-156.eu-west-1.compute.amazonaws.com/keystore.jks
  keystore_password      => 'SuperSecret',
  truststore_file_source => 'file:///vagrant/data/nifi/truststore.jks', # or https://ec2-33-238-128-156.eu-west-1.compute.amazonaws.com/truststore.jks
  truststore_password    => 'SuperSecret',
  admin                  => 'DC=com, DC=nifi, CN=admin',
  key_password           => 'SuperSecretUser',
  require                => [Class['java','ruby::dev'], Package['libcurl4-openssl-dev', 'zlib1g-dev']]
  } ->
exec { 'sleep_4_nifi_service' :
  require => Service["nifi"],
  command => 'sleep 60',
  path    => "/usr/bin:/bin:/usr/sbin",
}

nifi_pg {'test':
  ensure   => present,
  secure   => true,
  host     => $facts[networking][ip],
  cert     => '/vagrant/data/nifi/admin-cert.pem',
  cert_key => '/vagrant/data/nifi/admin-private-key.pem',
  require  => Exec['sleep_4_nifi_service'],
}

nifi_template {'IN.hmStaff.taskStatus.xml':
  ensure   => present,
  path     => 'http://ec2-54-171-7-117.eu-west-1.compute.amazonaws.com/nifi/IN.hmStaff.taskStatus.xml', # or /vagrant/data/nifi/IN.hmStaff.taskStatus.xml
  secure   => true,
  cert     => '/vagrant/data/nifi/admin-cert.pem',
  cert_key => '/vagrant/data/nifi/admin-private-key.pem',
  require  => Exec['sleep_4_nifi_service'],
}
```

After a "repuppet", you can access your nifi server https://<nifi_ip>:9443/nifi

## Authors:

Israel Calvete Talavera <icalvete@gmail.com>
