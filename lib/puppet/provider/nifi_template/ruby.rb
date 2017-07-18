require 'nifi_sdk_ruby'

Puppet::Type.type(:nifi_template).provide(:ruby) do

    def init
      schema        = 'http'
      port          = 8080
      cert          = nil
      cert_key      = nil
      cert_password = nil

      if :secure
        schema        = 'https'
        port          = 9443
        cert          = resource[:cert]
        cert_key      = resource[:cert_key]
        cert_password = resource[:cert_password]
      end

      nifi_client = Nifi.new(
        :schema        => schema,
        :port          => port,
        :cert          => cert.to_s,
        :cert_key      => cert_key.to_s,
        :cert_password => cert_password.to_s
      )
      nifi_client.set_debug true
    end

    def create
      schema        = 'http'
      port          = 8080
      cert          = nil
      cert_key      = nil
      cert_password = nil

      if :secure
        schema        = 'https'
        port          = 9443
        cert          = resource[:cert]
        cert_key      = resource[:cert_key]
        cert_password = resource[:cert_password]
      end

      nifi_client = Nifi.new(
        :schema        => schema,
        :port          => port,
        :cert          => cert.to_s,
        :cert_key      => cert_key.to_s,
        :cert_password => cert_password.to_s
      )
      nifi_client.set_debug true
      nifi_client.upload_template(:path => resource[:path])
    end

    def destroy
      schema        = 'http'
      port          = 8080
      cert          = nil
      cert_key      = nil
      cert_password = nil

      if :secure
        schema        = 'https'
        port          = 9443
        cert          = resource[:cert]
        cert_key      = resource[:cert_key]
        cert_password = resource[:cert_password]
      end

      nifi_client = Nifi.new(
        :schema        => schema,
        :port          => port,
        :cert          => cert.to_s,
        :cert_key      => cert_key.to_s,
        :cert_password => cert_password.to_s
      )
      nifi_client.set_debug true
      t_id = nifi_client.get_template_by_name resource[:name]
      nifi_client.delete_template t_id
    end

    def exists?
      schema        = 'http'
      port          = 8080
      cert          = nil
      cert_key      = nil
      cert_password = nil

      if :secure
        schema        = 'https'
        port          = 9443
        cert          = resource[:cert]
        cert_key      = resource[:cert_key]
        cert_password = resource[:cert_password]
      end

      nifi_client = Nifi.new(
        :schema        => schema,
        :port          => port,
        :cert          => cert.to_s,
        :cert_key      => cert_key.to_s,
        :cert_password => cert_password.to_s
      )
      nifi_client.set_debug true
      nifi_client.template_by_name? resource[:name]
    end
end
