module SpreeAddOn
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false

      def add_javascripts
        append_file "vendor/assets/javascripts/spree/backend/all.js",
                    "//= require spree/backend/spree_add_on\n"
      end

      # rubocop:disable Metrics/MethodLength
      def add_stylesheets
        inject_into_file "vendor/assets/stylesheets/spree/backend/all.css",
                         " *= require spree/backend/spree_add_on\n",
                         before: %r{ \*\/ }, verbose: true
        inject_into_file "vendor/assets/stylesheets/spree/frontend/all.css",
                         " *= require spree/frontend/spree_add_on\n",
                         before: %r{ \*\/ }, verbose: true
      end
      # rubocop:enable Metrics/MethodLength

      def add_migrations
        run "bundle exec rake railties:install:migrations FROM=spree_add_on"
      end

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Rails/Output
      def run_migrations
        run_migrations = options[:auto_run_migrations] ||
                         ["", "y", "Y"].include?(
                           ask("Would you like to run migrations now? [Y/n]")
                         )
        if run_migrations
          run "bundle exec rake db:migrate"
        else
          puts "Skipping rake db:migrate, don't forget to run it!"
        end
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Rails/Output
    end
  end
end
