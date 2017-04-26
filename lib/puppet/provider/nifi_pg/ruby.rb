require 'nifi_sdk_ruby'

Puppet::Type.type(:nifi_pg).provide(:ruby) do

    def init
      nifi_client = Nifi.new()
      nifi_client.set_debug true
    end

    def create
      nifi_client = Nifi.new()
      nifi_client.set_debug true
      nifi_client.create_process_group(:name => resource[:name])
    end

    def destroy
      nifi_client = Nifi.new()
      nifi_client.set_debug true
      pg = nifi_client.get_process_group_by_name resource[:name]
      nifi_client.delete_process_group pg['id']
    end

    def exists?
      nifi_client = Nifi.new()
      nifi_client.set_debug true 
      nifi_client.process_group_by_name? resource[:name]
    end
end
