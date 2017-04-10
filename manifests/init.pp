class nifi (

  $version               = $nifi::params::version,
  $root_path             = $nifi::params::root_path,
  $repo_scheme           = $nifi::params::repo_scheme,
  $repo_domain           = $nifi::params::repo_domain,
  $repo_port             = $nifi::params::repo_port,
  $repo_user             = $nifi::params::repo_user,
  $repo_pass             = $nifi::params::repo_pass,
  $repo_path             = regsubst($nifi::params::repo_path, 'NIFIVERSION', $version),
  $repo_resource         = regsubst($nifi::params::repo_resource, 'NIFIVERSION', $version),
  $repo_toolkit_resource = regsubst($nifi::params::repo_toolkit_resource, 'NIFIVERSION', $version)

) inherits nifi::params {

  anchor {'nifi::begin':
    before => Class['nifi::install']
  }
  class {'nifi::install':
    require => Anchor['nifi::begin']
  }
  class {'nifi::config':
    require => Class['nifi::install']
  }
  class {'nifi::service':
    subscribe => Class['nifi::config']
  }
  anchor {'nifi::end':
    require => Class['nifi::service']
  }
}
