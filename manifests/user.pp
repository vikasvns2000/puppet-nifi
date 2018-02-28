define nifi::user {

  $nifi_user_uuid = fqdn_uuid($name)

  $user_changes_users = [
    "defnode user user[#attribute/identifier='${nifi_user_uuid}'] ''",
    "set \$user/#attribute/identifier '${nifi_user_uuid}'",
    "set \$user/#attribute/identity '$name'",
  ]

  augeas{"nifi_user_users_${name}" :
    incl    => "/opt/nifi-${nifi::version}/conf/users.xml",
    context => "/files/opt/nifi-${nifi::version}/conf/users.xml/tenants/users",
    lens    => 'Xml.lns',
    changes => $user_changes_users,
  }

  $user_changes_authorizations = [
    "defvar policy policy[#attribute/resource='/flow']",
    "defnode user \$policy/user[#attribute/identifier='${nifi_user_uuid}'] ''",
    "set \$user/#attribute/identifier '${nifi_user_uuid}'",
  ]

  augeas{"nifi_user_authorizations_${name}" :
    incl    => "/opt/nifi-${nifi::version}/conf/authorizations.xml",
    context => "/files/opt/nifi-${nifi::version}/conf/authorizations.xml/authorizations/policies",
    lens    => 'Xml.lns',
    changes => $user_changes_authorizations,
  }

  exec { "restart_nifi_service_${name}" :
    command => 'service nifi restart && sleep 60',
    path    => '/usr/bin:/bin:/usr/sbin',
    require => Augeas["nifi_user_users_${name}", "nifi_user_authorizations_${name}"],
    unless  => "/bin/grep -Pzo 'flow(.|\\n)*?${nifi_user_uuid}' /opt/nifi-${nifi::version}/conf/authorizations.xml"
  }
}
