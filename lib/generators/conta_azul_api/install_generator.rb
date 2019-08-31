require 'rails/generators/active_record'

module ContaAzulApi
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      desc 'add the migrations'
      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end

        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template(
          'conta_azul_api_create_ca_auth_history.rb',
          "db/migrate/conta_azul_api_create_ca_auth_history.rb",
          migration_version: migration_version
        )
      end

      private

      def migration_version
        if rails5_and_up?
          "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        end
      end

      def rails5_and_up?
        Rails::VERSION::MAJOR >= 5
      end
    end
  end
end
