class nifi::service {

  service { 'nifi':
    enable     => true,
    ensure     => running,
    hasstatus  => false,
    hasrestart => false,
    provider   => 'systemd'
  }
}

