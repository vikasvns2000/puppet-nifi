class nifi::install {

  $source         = "${nifi::repo_scheme}://${nifi::repo_domain}/${nifi::repo_path}/${nifi::repo_resource}"
  $source_toolkit = "${nifi::repo_scheme}://${nifi::repo_domain}/${nifi::repo_path}/${nifi::repo_toolkit_resource}"

  if $rubysitedir =~ /puppetlabs/ {
    $nifi_sdk_ruby_provider = 'puppet_gem'
  } else {
    $nifi_sdk_ruby_provider = 'gem'
  }

  package { 'nifi_sdk_ruby':
    ensure   => present,
    provider => $nifi_sdk_ruby_provider
  }

  wget::fetch {'nifi_get_package':
    source      => $source,
    user        => $nifi::repo_user,
    password    => $nifi::repo_pass,
    destination => "/tmp/${nifi::repo_resource}",
    timeout     => 0,
    verbose     => false,
  }

  wget::fetch {'nifi_get_toolkit_package':
    source      => $source_toolkit,
    user        => $nifi::repo_user,
    password    => $nifi::repo_pass,
    destination => "/tmp/${nifi::repo_toolkit_resource}",
    timeout     => 0,
    verbose     => false,
  }

  exec {'nifi_install_package':
    cwd     => '/opt/',
    command => "/bin/tar xvfz /tmp/${nifi::repo_resource}",
    require => Wget::Fetch['nifi_get_package'],
    unless  => "/usr/bin/test -d /opt/nifi-${nifi::version}"
  }

  exec {'nifi_install_toolkit_package':
    cwd     => '/opt/',
    command => "/bin/tar xvfz /tmp/${nifi::repo_toolkit_resource}",
    require => Wget::Fetch['nifi_get_toolkit_package'],
    unless  => "/usr/bin/test -d /opt/nifi-toolkit-${nifi::version}"
  }

  include ::systemd

  file { '/etc/systemd/system/nifi.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/nifi.service.erb"),
    require => Exec['nifi_install_package']
  } ~>
  Exec['systemctl-daemon-reload']
}

