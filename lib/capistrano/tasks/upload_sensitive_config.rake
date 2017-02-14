before 'deploy:migrate', 'deploy:upload_sensitive_config'

namespace :deploy do
  desc 'Uploads sensitive configuration files'
  task :upload_sensitive_config do
    FILES = ['database.yml', 'secrets.yml']
    on roles(:db) do
      # within "#{current_path}" do
        with rails_env: "#{fetch(:stage)}" do
          FILES.each { |name|
            upload! "#{SECURE_DATA}/environments/#{SENSITIVE_DIR}/#{name}", "#{release_path}/config/"
          }
        end
      # end
    end
  end
end