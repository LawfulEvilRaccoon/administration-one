require "rails/generators/active_record"

module Admin
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      def add_field_error_proc
        field_error_proc_code = <<~RUBY
          # Provides an HTML generator for displaying errors that come from Active Model
          config.action_view.field_error_proc = Proc.new do |html_tag, instance|
            raw Nokogiri::HTML.fragment(html_tag).child.add_class("is-invalid")
          end
        RUBY

        environment field_error_proc_code
      end

      def generate_authentication
        system "bin/rails generate authentication"
      end

      def install_active_storage
        system "bin/rails active_storage:install"
      end

      def remove_default_users_migration
        users_migration_filename = Dir.children('./db/migrate').find { |c| c.include?('users') }
        File.delete("db/migrate/#{users_migration_filename}")
      end

      def add_gems
        uncomment_lines "Gemfile", /"bcrypt"/
        gem "pagy", comment: "Use Pagy to add paginated results [https://github.com/ddnexus/pagy]"
        gem "ransack", comment: "Use Ransack to enable the creation of search forms for your application [https://github.com/activerecord-hackery/ransack]"
        gem "spreadsheet_architect", comment: "Spreadsheet Architect is a library that allows you to create XLSX, ODS, or CSV spreadsheets super easily [https://github.com/westonganger/spreadsheet_architect]"
      end

      def create_db_files
        copy_file "seeds.rb", "db/seeds.rb", force: true
        migration_template "migrations/create_users.rb", "#{db_migrate_path}/create_users.rb"
      end

      def create_models
        directory "models/admin", "app/models/admin"
        copy_file "models/application_record.rb", "app/models/application_record.rb", force: true
        copy_file "models/user.rb", "app/models/user.rb", force: true
      end

      def create_fixture_file
        File.delete("test/fixtures/users.yml")
        copy_file "test_unit/users.yml", "test/fixtures/users.yml"
      end

      def create_controllers
        directory "controllers", "app/controllers", force: true
      end

      def create_views
        directory "erb", "app/views"
      end

      def create_helpers
        directory "helpers", "app/helpers"
      end

      def create_mailers
        directory "mailers", "app/mailers"
      end

      def create_images
        directory "images", "app/assets/images"
      end

      def create_jobs
        directory "jobs", "app/jobs"
      end

      def copy_css_files
        directory "css", "app/assets/stylesheets/admin"
      end

      def copy_javascript
        directory "js", "app/javascript/admin"
      end

      def add_routes
        route "get '/', to: 'home#index', as: 'root'", namespace: :admin
        route "resource  :password_reset", namespace: :admin
        route "resources :users", namespace: :admin
        route "get    'sign_in',  to: 'sessions#new'", namespace: :admin
        route "post   'sign_in',  to: 'sessions#create'", namespace: :admin
        route "post 'sign_out', to: 'sessions#destroy'", namespace: :admin
        route "root to: 'admin/home#index'"
        route 'get "profile", to: "profile#show"', namespace: :admin
        route 'get "edit_profile", to: "profile#edit", as: "edit_profile"', namespace: :admin
        route 'patch "profile", to: "profile#update"', namespace: :admin
      end

      def create_test_files
        File.delete('test/models/user_test.rb')
        directory "test_unit/controllers", "test/controllers"
        directory "test_unit/models", "test/models"
        copy_file "test_unit/test_helper.rb", "test/test_helper.rb", force: true
      end

      def add_avatars_storage_config
        inject_into_file "config/storage.yml", "avatars_local_storage:\n" +
          "  service: Disk\n" +
          "  root: <%= Rails.root.join(\"storage\", \"avatar_uploads_\#{Rails.env}\") %>"
      end

      def restart_server
        system "bin/rails restart"
      end
    end
  end
end
