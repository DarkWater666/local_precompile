Rake::Task['deploy:compile_assets'].clear

namespace :load do
  task :defaults do
    set :assets_dir, 'public/assets'
    set :packs_dir, 'public/packs'
    set :rsync_cmd, 'rsync -av --delete'
    set :assets_role, 'web'
    set :skip_assets, ENV['skip_assets'] || false
    set :package_file, fetch(:package_file, 'package.json')

    unless fetch(:skip_assets)
      before 'deploy:check:directories', 'deploy:assets:validate'
      after 'bundler:install', 'deploy:assets:prepare'
      after 'deploy:assets:prepare', 'deploy:assets:rsync'
      after 'deploy:assets:rsync', 'deploy:assets:cleanup'
    end
  end
end

namespace :deploy do
  namespace :assets do
    desc 'Remove all local precompiled assets'
    task :cleanup do
      run_locally do
        execute 'rm', '-rf', fetch(:assets_dir)
        execute 'rm', '-rf', fetch(:packs_dir)
      end
    end

    desc 'Actually precompile the assets locally'
    task :prepare do
      invoke 'deploy:assets:cleanup'

      run_locally do
        execute 'ASSETS_PRECOMPILE=true RAILS_ENV=production DB_ADAPTER=nulldb rake assets:clean'
        execute 'ASSETS_PRECOMPILE=true RAILS_ENV=production DB_ADAPTER=nulldb rake assets:precompile'
      end
    end

    desc 'Performs rsync to app servers'
    task :rsync do
      on roles(fetch(:assets_role)), in: :parallel do |server|
        run_locally do
          remote_shell = %(-e "ssh -p #{server.port}") if server.port

          commands = []
          commands << "#{fetch(:rsync_cmd)} #{remote_shell} ./#{fetch(:assets_dir)}/ #{server.user}@#{server.hostname}:#{release_path}/#{fetch(:assets_dir)}/" if Dir.exists?(fetch(:assets_dir))
          commands << "#{fetch(:rsync_cmd)} #{remote_shell} ./#{fetch(:packs_dir)}/ #{server.user}@#{server.hostname}:#{release_path}/#{fetch(:packs_dir)}/" if Dir.exists?(fetch(:packs_dir))

          commands.each do |command|
            if dry_run?
              SSHKit.config.output.info command
            else
              execute command
            end
          end
        end
      end
    end

    desc 'Check frontend tools valid versions'
    task :validate do
      set :package_file, fetch(:package_file, 'package.json')

      on roles(fetch(:assets_role)) do
        run_locally do
          invoke 'deploy:assets:node:presence'
          invoke 'deploy:assets:yarn:presence'

          enabled_node_version = capture('node', '--version').tr('v', '')
          enabled_yarn_version = capture('yarn', '--version').tr('v', '')
          package = JSON.parse File.read(fetch(:package_file)), symbolize_names: true, quirks_mode: true
          needed_node_version, needed_yarn_version = package[:engines].values_at(:node, :yarn)

          if enabled_node_version != needed_node_version
            warn 'Node.js version is wrong'
            exit 1
          end

          if enabled_yarn_version != needed_yarn_version
            warn 'Yarn version is wrong'
            exit 1
          end

          info 'Frontend engine versions is ok'
        end
      end
    end

    namespace :node do
      task :presence do
        on roles(fetch(:assets_role)) do
          run_locally do
            unless test('node', '--version')
              warn 'Node.js is not installed'
              exit 1
            end
          end
        end
      end
    end

    namespace :yarn do
      task :presence do
        on roles(fetch(:assets_role)) do
          run_locally do
            unless test('yarn', '--version')
              warn 'Yarn is not installed'
              exit 1
            end
          end
        end
      end
    end
  end
end
