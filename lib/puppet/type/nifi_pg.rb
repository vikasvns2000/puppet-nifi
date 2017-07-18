require 'puppet/parameter/boolean'

Puppet::Type.newtype(:nifi_pg) do
  @doc = "Manage Nifi process groups"

  ensurable

  newparam(:secure, :boolean => false, :parent => Puppet::Parameter::Boolean) do

    desc "Is nifi ssl secured?"

    validate do |value|
    end
  end

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

  newparam(:cert) do
    desc "Client certificate."

    validate do |value|
      unless File.exists? value
        raise ArgumentError, "%s does not exists" % value
      end
    end
  end

  newparam(:cert_key) do
    desc "Client certificate key."

    validate do |value|
      unless File.exists? value
        raise ArgumentError, "%s does not exists" % value
      end
    end
  end

  newparam(:cert_password) do
    desc "Client certificate password."

    validate do |value|
    end
  end
end
