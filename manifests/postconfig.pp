class nifi::postconfig {

  $nifi_resources_uuid      = fqdn_uuid('resources')
  $nifi_processors_uuid     = fqdn_uuid('processors')
  $nifi_process_groups_uuid = fqdn_uuid('process-groups')

  exec { 'persists_nifi_authorizations' :
    require => Service["nifi"],
    command => "sleep 60 && rm /opt/nifi-${nifi::version}/conf/authorizations.xml && service nifi restart && sleep 60",
    path    => "/usr/bin:/bin:/usr/sbin",
  }

  $resources_changes = [
    "defnode policy policy[#attribute/identifier='${nifi_resources_uuid}'] ''",
    "set \$policy/#attribute/identifier '${nifi_resources_uuid}'",
    "set \$policy/#attribute/resource '/resources'",
    "set \$policy/#attribute/action 'R'",
    "set \$policy/user/#attribute/identifier '${nifi::nifi_admin_uuid}'",
  ]

  $processors_changes = [
    "defnode policy policy[#attribute/identifier='${nifi_processors_uuid}'] ''",
    "set \$policy/#attribute/identifier '${nifi_processors_uuid}'",
    "set \$policy/#attribute/resource '/processors'",
    "set \$policy/#attribute/action 'W'",
    "set \$policy/user/#attribute/identifier '${nifi::nifi_admin_uuid}'",
  ]

  $process_groups_changes = [
    "defnode policy policy[#attribute/identifier='${nifi_process_groups_uuid}'] ''",
    "set \$policy/#attribute/identifier '${nifi_process_groups_uuid}'",
    "set \$policy/#attribute/resource '/process-groups'",
    "set \$policy/#attribute/action 'W'",
    "set \$policy/user/#attribute/identifier '${nifi::nifi_admin_uuid}'",
  ]

  augeas{'nifi_api_resources' :
    incl    => "/opt/nifi-${nifi::version}/conf/authorizations.xml",
    context => "/files/opt/nifi-${nifi::version}/conf/authorizations.xml/authorizations/policies",
    lens    => 'Xml.lns',
    changes => $resources_changes,
    require => Exec['persists_nifi_authorizations']
  }

  #augeas{'nifi_api_processors' :
  #  incl    => "/opt/nifi-${nifi::version}/conf/authorizations.xml",
  #  context => "/files/opt/nifi-${nifi::version}/conf/authorizations.xml/authorizations/policies",
  #  lens    => 'Xml.lns',
  #  changes => $processors_changes,
  #  require => Exec['persists_nifi_authorizations']
  #}

  #augeas{'nifi_api_process_groups' :
  #  incl    => "/opt/nifi-${nifi::version}/conf/authorizations.xml",
  #  context => "/files/opt/nifi-${nifi::version}/conf/authorizations.xml/authorizations/policies",
  #  lens    => 'Xml.lns',
  #  changes => $process_groups_changes,
  #  require => Exec['persists_nifi_authorizations']
  #}

  exec { 'restart_nifi_service' :
    command => 'service nifi restart',
    path    => '/usr/bin:/bin:/usr/sbin',
    require => Augeas['nifi_api_resources']
  }
  #require => Augeas['nifi_api_resources', 'nifi_api_processors', 'nifi_api_process_groups']
}
