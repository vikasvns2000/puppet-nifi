require 'puppet/parameter/boolean'
require 'net/http'
require 'uri'

Puppet::Type.newtype(:nifi_template) do
  @doc = "Manage Nifi templates"

  ensurable

  newparam(:secure, :boolean => false, :parent => Puppet::Parameter::Boolean) do

    desc "Is nifi ssl secured?"

    validate do |value|
    end
  end

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

  newparam(:host) do
    desc "Nifi host"

    validate do |value|
    end
  end

  newparam(:path) do
    desc "Template path"

    validate do |value|
      if value =~ URI::regexp

        uri = URI.parse(value)
        client = Net::HTTP.new(uri.host, uri.port)
        if uri.scheme == 'https'
          client.use_ssl = true
        end

        request = Net::HTTP::Get.new(uri.request_uri)
        response = client.request(request)

        raise Puppet::Error, 'path (url) fails.' unless response.code.to_i == 200
      else
        unless File.exists? value
          raise ArgumentError, "%s does not exists" % value
        end
      end
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
