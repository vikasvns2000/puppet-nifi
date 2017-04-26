require 'nifi_sdk_ruby'

Puppet::Type.type(:nifi_template).provide(:ruby) do

    def init
      nifi_client = Nifi.new()
      nifi_client.set_debug true
    end

    def create
      nifi_client = Nifi.new()
      nifi_client.set_debug true
      nifi_client.upload_template(:path => resource[:path])
    end

    def destroy
      nifi_client = Nifi.new()
      nifi_client.set_debug true
      t_id = nifi_client.get_template_by_name resource[:name]
      nifi_client.delete_delete t_id
    end

    def exists?
      nifi_client = Nifi.new()
      nifi_client.set_debug true
      nifi_client.template_by_name? resource[:name]
    end
end
