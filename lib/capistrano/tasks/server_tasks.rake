before 'deploy:starting', 'deploy:shutdown_server'
before 'deploy:finished', 'deploy:start_server'

namespace :deploy do
  desc 'Shut down the server'
  task :shutdown_server do
    on roles(:db) do
      with rails_env: "#{fetch(:stage)}" do
        execute :sudo, "service quotr stop"
      end
    end
  end

  desc 'Start the server'
  task :start_server do
    on roles(:db) do
      with rails_env: "#{fetch(:stage)}" do
        execute :sudo, "service quotr start"
      end
    end
  end
end