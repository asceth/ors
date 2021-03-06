module ORS::Commands

  class Setup < Base

    def execute
      info "setting up #{name} #{environment}..."

      info "Are you sure? ('yes' + ctrl+D^2)"
      if pretending || STDIN.read == "yes"
        execute_in_parallel(all_servers) {|server| setup_repo server }

        run Ruby

        execute_command migration_server, prepare_environment,
                                          %(RAILS_ENV=#{environment} bundle exec rake db:create)
      else
        info "Setup aborted."
      end
    end

  end

end
