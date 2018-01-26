require 'nifi_sdk_ruby'

Puppet::Type.type(:nifi_pg).provide(:ruby) do

    def init
      schema        = 'http'
      host          = resource[:host]
      port          = 8080
      cert          = nil
      cert_key      = nil
      cert_password = nil

      if :secure
        schema        = 'https'
        host          = resource[:host]
        port          = 9443
        cert          = resource[:cert]
        cert_key      = resource[:cert_key]
        cert_password = resource[:cert_password]
      end

      nifi_client = Nifi.new(
        :schema        => schema,
        :host          => host,
        :port          => port,
        :cert          => cert.to_s,
        :cert_key      => cert_key.to_s,
        :cert_password => cert_password.to_s
      )
      nifi_client.set_debug true
    end

    def create
      schema        = 'http'
      host          = resource[:host]
      port          = 8080
      cert          = nil
      cert_key      = nil
      cert_password = nil

      if :secure
        schema        = 'https'
        host          = resource[:host]
        port          = 9443
        cert          = resource[:cert]
        cert_key      = resource[:cert_key]
        cert_password = resource[:cert_password]
      end

      nifi_client = Nifi.new(
        :schema        => schema,
        :host          => host,
        :port          => port,
        :cert          => cert.to_s,
        :cert_key      => cert_key.to_s,
        :cert_password => cert_password.to_s
      )
      nifi_client.set_debug true
      nifi_client.create_process_group(:name => resource[:name])
    end

    def destroy
      schema        = 'http'
      host          = resource[:host]
      port          = 8080
      cert          = nil
      cert_key      = nil
      cert_password = nil

      if :secure
        schema        = 'https'
        host          = resource[:host]
        port          = 9443
        cert          = resource[:cert]
        cert_key      = resource[:cert_key]
        cert_password = resource[:cert_password]
      end

      nifi_client = Nifi.new(
        :schema        => schema,
        :host          => host,
        :port          => port,
        :cert          => cert.to_s,
        :cert_key      => cert_key.to_s,
        :cert_password => cert_password.to_s
      )
      nifi_client.set_debug true
      pg = nifi_client.get_process_group_by_name resource[:name]
      nifi_client.delete_process_group pg['id']
    end

    def exists?
      schema        = 'http'
      host          = resource[:host]
      port          = 8080
      cert          = nil
      cert_key      = nil
      cert_password = nil

      if :secure
        schema        = 'https'
        host          = resource[:host]
        port          = 9443
        cert          = resource[:cert]
        cert_key      = resource[:cert_key]
        cert_password = resource[:cert_password]
      end

      nifi_client = Nifi.new(
        :schema        => schema,
        :host          => host,
        :port          => port,
        :cert          => cert.to_s,
        :cert_key      => cert_key.to_s,
        :cert_password => cert_password.to_s
      )
      nifi_client.set_debug true
      nifi_client.process_group_by_name? resource[:name]
    end
end
