Puppet::Type.newtype(:nifi_template) do
  @doc = "Manage Nifi templates"
  
  ensurable

  newparam(:name) do
  
    isnamevar

    desc "Template Name"

    validate do |value|
    end
  end
  
  newparam(:id) do
    desc "Template ID"

    validate do |value|
    end
  end
  
  newparam(:path) do
    desc "Template path"

    validate do |value|
    end
  end
end
