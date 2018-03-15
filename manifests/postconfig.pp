class nifi::postconfig {

  $nifi_resources_uuid      = fqdn_uuid('resources')
  $nifi_processors_uuid     = fqdn_uuid('processors')
  $nifi_process_groups_uuid = fqdn_uuid('process-groups')

  exec { 'persists_nifi_authorizations' :
    require => Service["nifi"],
    command => "sleep 91 &&  rm /opt/nifi-${nifi::version}/conf/authorizations.xml && service nifi restart && sleep 92",
    path    => "/usr/bin:/bin:/usr/sbin",
    unless  => "/bin/grep 'data/process-groups' /opt/nifi-${nifi::version}/conf/authorizations.xml"
  }

  $resources_changes = [
    "defnode policy policy[#attribute/identifier='${nifi_resources_uuid}'] ''",
    "set \$policy/#attribute/identifier '${nifi_resources_uuid}'",
    "set \$policy/#attribute/resource '/resources'",
    "set \$policy/#attribute/action 'R'",
    "set \$policy/user/#attribute/identifier '${nifi::nifi_admin_uuid}'",
  ]

  augeas{'nifi_api_resources' :
    incl    => "/opt/nifi-${nifi::version}/conf/authorizations.xml",
    context => "/files/opt/nifi-${nifi::version}/conf/authorizations.xml/authorizations/policies",
    lens    => 'Xml.lns',
    changes => $resources_changes,
    require => Exec['persists_nifi_authorizations']
  }

  exec { 'restart_nifi_service_postconfig' :
    command => 'service nifi restart && sleep 93',
    path    => '/usr/bin:/bin:/usr/sbin',
    require => Augeas['nifi_api_resources'],
    unless  => "/bin/grep resources.*${nifi::nifi_admin_uuid} /opt/nifi-${nifi::version}/conf/authorizations.xml"
  }
}
