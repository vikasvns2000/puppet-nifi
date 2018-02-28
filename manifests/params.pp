class nifi::params {

  case $::operatingsystem {
    /^(Debian|Ubuntu)$/: {
    }
    default: {
      fail ("${::operatingsystem} not supported.")
    }
  }

  $version               = '1.5.0'
  $root_path             = '/opt'
  $repo_scheme           = 'http'
  $repo_domain           = 'archive.apache.org'
  $repo_port             = false
  $repo_user             = false
  $repo_pass             = false
  $repo_path             = 'dist/nifi/NIFIVERSION'
  $repo_resource         = 'nifi-NIFIVERSION-bin.tar.gz'
  $repo_toolkit_resource = 'nifi-toolkit-NIFIVERSION-bin.tar.gz'
}

