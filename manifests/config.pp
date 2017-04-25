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
}

