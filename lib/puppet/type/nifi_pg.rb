Puppet::Type.newtype(:nifi_pg) do
  @doc = "Manage Nifi process groups"
  
  ensurable

  newparam(:name) do
  
    isnamevar

    desc "Process group Name"

    validate do |value|
    end
  end
  
  newparam(:id) do
    desc "Process group ID"

    validate do |value|
    end
  end
end
