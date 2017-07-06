class nifi::config {

  # FROM https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html#configuration-best-practices

  # Maximum File Handles
  $nofile = '50000'

  limits::fragment {
    'root/soft/nofile': value => $nofile;
    '*/soft/nofile': value    => $nofile;
    'root/hard/nofile': value => $nofile;
    '*/hard/nofile': value    => $nofile;
  }

  # Maximum Forked Processes
  $forks = '10000'

  limits::fragment {
    'root/soft/nproc': value => $forks;
    '*/soft/nproc': value    => $forks;
    'root/hard/nproc': value => $forks;
    '*/hard/nproc': value    => $forks;
  }

  # Tell Linux you never want NiFi to swap
  sysctl::value { 'vm.swappiness':
    ensure => 'present',
    value  => 0
  }

  # Increase the number of TCP socket ports available
  sysctl::value { 'net.ipv4.ip_local_port_range':
    ensure => 'present',
    value  => "10000 65000"
  }

  # Set how long sockets stay in a TIMED_WAIT state when closed
  sysctl::value { 'net.ipv4.netfilter.ip_conntrack_tcp_timeout_time_wait':
    ensure => 'present',
    value  => "10000 65000"
  }

  if $nifi::secure {
    if 'http://' in $nifi::keystore_file_source or 'https://' in $nifi::keystore_file_source {

      wget::fetch {'nifi_keystore_file':
        source             => $nifi::keystore_file_source,
        destination        => "/opt/nifi-${nifi::version}/conf/keystore.jks",
        timeout            => 0,
        verbose            => false,
        nocheckcertificate => true,
        unless             => "/usr/bin/test -f /opt/nifi-${nifi::version}/conf/keystore.jks"
      }
    } elsif 'file://' in $nifi::keystore_file_source {
      notify{'nifi_keystore_file from File':}
    } else {
      notify{'nifi_keystore_file from Puppet':}
    }
  }

  if $nifi::auth == 'cert' {
    if 'http://' in $nifi::truststore_file_source or 'https://' in $nifi::truststore_file_source {

      wget::fetch {'nifi_truststore_file':
        source             => $nifi::truststore_file_source,
        destination        => "/opt/nifi-${nifi::version}/conf/truststore.jks",
        timeout            => 0,
        verbose            => false,
        nocheckcertificate => true,
        unless             => "/usr/bin/test -f /opt/nifi-${nifi::version}/conf/truststore.jks"
      }
    } elsif 'file://' in $nifi::truststore_file_source {
      notify{'truststore_file_source from File':}
    } else {
      notify{'truststore_file_source from puppet':}
    }
  }

  file { 'nifi_properties':
    ensure  => present,
    path    => "/opt/nifi-${nifi::version}/conf/nifi.properties",
    content => template("${module_name}/nifi.properties.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }

  augeas{'nifi_admin_user' :
    incl    => "/opt/nifi-${nifi::version}/conf/authorizers.xml",
    context => "/files/opt/nifi-${nifi::version}/conf/authorizers.xml",
    lens    => 'Xml.lns',
    changes => [
      "set /files/opt/nifi-${nifi::version}/conf/authorizers.xml/authorizers/authorizer/property[#attribute[name='Initial Admin Identity']]/#text '${nifi::admin}'",
    ]
  }
}
