require "rails/generators/resource_helpers"

module Admin
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      remove_class_option :actions

      class_option :orm, banner: "NAME", type: :string, required: true, desc: "ORM to generate the controller for"

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      source_root File.expand_path("templates", __dir__)

      def ask_about_wysiwyg
        return if behavior == :revoke
        if attributes_names.include?("content")
          puts "\n" * 2
          puts "There was attribute named \"content\" passed to generator's options. Do you want to use EditorJS for it?"
          answer = ask "Type \"Y\" or \"Yes\ to use EditorJS. Or anything else not to use it."
          [ "y", "yes" ].include?(answer.downcase) ? @use_editor_js = true : @use_editor_js = false
        end
      end

      def copy_files
        directory "erb", "app/views/admin/#{file_name.pluralize}"

        template "controller.rb", "app/controllers/admin/#{controller_file_name}_controller.rb"

        template "functional_test.rb", "test/controllers/admin/#{controller_file_name}_controller_test.rb"
      end

      def create_routes
        route "resources :#{file_name.pluralize}", namespace: :admin
      end

      def navigation_link
        insert_into_file "app/views/admin/base/_secondary_navbar_links.html.erb", "\n" + <<-EOF
<!-- Link for #{file_name.pluralize.capitalize} -->
<li class="nav-item <%= active_nav_item("admin/#{file_name.pluralize}") %>">
  <%= link_to admin_#{file_name.pluralize}_path, class: "nav-link" do %>
    <span class="nav-link-icon d-md-none d-lg-inline-block">
      <!-- Replace this icon with icon from https://tabler.io/icons -->
      <svg  xmlns="http://www.w3.org/2000/svg"  width="24"  height="24"  viewBox="0 0 24 24"  fill="none"  stroke="currentColor"  stroke-width="1"  stroke-linecap="round"  stroke-linejoin="round"  class="icon icon-tabler icons-tabler-outline icon-tabler-info-hexagon"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M19.875 6.27c.7 .398 1.13 1.143 1.125 1.948v7.284c0 .809 -.443 1.555 -1.158 1.948l-6.75 4.27a2.269 2.269 0 0 1 -2.184 0l-6.75 -4.27a2.225 2.225 0 0 1 -1.158 -1.948v-7.285c0 -.809 .443 -1.554 1.158 -1.947l6.75 -3.98a2.33 2.33 0 0 1 2.25 0l6.75 3.98h-.033z" /><path d="M12 9h.01" /><path d="M11 12h1v4h1" /></svg>
    </span>
    <span class="nav-link-title">
      #{file_name.pluralize.capitalize}
    </span>
  <% end %>
</li>
EOF

        if behavior == :revoke
          regexp = /<!-- Link for #{file_name.pluralize.capitalize}(?:\s*>|\s+(?:(?:[^=\s]*?(?:=(?:(?:"[^"]*?")|(?:'[^']*?')))?)\s*)*>).*?<\/\s*li>/mi
          gsub_file "app/views/admin/base/_secondary_navbar_links.html.erb", regexp, "", force: true
        end
      end

      def add_ransackable_attributes_to_model
        file = "app/models/#{singular_table_name}.rb"
        insertion = "  def self.ransackable_attributes(auth_object = nil)\n    #{attributes_to_array_string}\n  end\n"
        if File.exist?(file)
          inject_into_class file, "#{class_name} < ApplicationRecord", insertion, force: true
        end
      end

      private
        def controller_class_path
          [ "admin" ]
        end

        def singular_route_name
          "#{controller_class_path.join('_')}_#{singular_table_name}"
        end

        def plural_route_name
          "#{controller_class_path.join('_')}_#{plural_table_name}"
        end

        def model_resource_name(base_name = singular_table_name, prefix: "")
          "[#{controller_class_path.map { |name| ":" + name }.join(", ")}, #{prefix}#{base_name}]"
        end

        def permitted_params
          attachments, others = attributes_names.partition { |name| attachments?(name) }
          params = others.map { |name| ":#{name}" }
          params += attachments.map { |name| "#{name}: []" }
          params.join(", ")
        end

        def attachments?(name)
          attribute = attributes.find { |attr| attr.name == name }
          attribute&.attachments?
        end

        def fixture_name
          table_name
        end

        def attributes_string
          attributes_hash.map { |k, v| "#{k}: #{v}" }.join(", ")
        end

        def attributes_to_array_string
          "%w[" + attributes_hash.map { |k, _| "#{k}" }.join(" ") + "]"
        end

        def attributes_hash
          return {} if attributes_names.empty?

          attributes_names.filter_map do |name|
            if %w[password password_confirmation].include?(name) && attributes.any?(&:password_digest?)
              [ "#{name}", '"secret"' ]
            elsif !virtual?(name)
              [ "#{name}", "@#{singular_table_name}.#{name}" ]
            end
          end.sort.to_h
        end

        def boolean?(name)
          attribute = attributes.find { |attr| attr.name == name }
          attribute&.type == :boolean
        end

        def virtual?(name)
          attribute = attributes.find { |attr| attr.name == name }
          attribute&.virtual?
        end
    end
  end
end
