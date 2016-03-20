Petra.configure do

  persistence_adapter.storage_directory = Rails.root.join('tmp', 'petra')
  log_level :warn

  configure_class ActiveRecord::Base do
    proxy_instances true
    lookup_method :find
    id_method :id
  end

end
