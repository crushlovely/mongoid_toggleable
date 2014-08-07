module Mongoid
  module Toggleable
    extend ActiveSupport::Concern

    included do
      extend ClassMethods
    end

    module ClassMethods
      # Public: Create a toggleable attribute on the model.
      #
      # toggleable_attribute - A symbol representing the name of the attribute to be created.
      # options - The Hash options used to customize the attribute (default: {}):
      #           :default             - The Boolean default of the attribute.
      #                                  (optional, default: true).
      #           :scope_name          - The Symbol representing the name of the positive scope
      #                                  (optional, default: #{toggleable_attribute}.
      #           :inverse_scope_name  - The Symbol representing the name of the positive scope
      #                                  (optional, default: #{toggleable_attribute}.
      #
      # Examples:
      #
      #   toggleable :for_sale, :default => false
      #   toggleable :visible, :inverse_scope_name => :hidden
      #   toggleable :publishable, :default => false, :inverse_scope_name => :unpublishable
      #   toggleable :featured, :default => true, :scope_name => :features
      #
      # Defines the attribute specified as well as relevant scopes.
      def toggleable(toggleable_attribute, options = {})
        defaults = {
          :default => true,
          :scope_name => toggleable_attribute,
          :inverse_scope_name => "not_#{toggleable_attribute}"
        }
        options = defaults.merge(options)

        field toggleable_attribute, :type => MongoidToggleable.boolean_type, :default => options[:default]
        scope options[:scope_name], -> { where(toggleable_attribute => true) }
        scope options[:inverse_scope_name], -> { where(toggleable_attribute => false) }
      end
    end

    # Public: Toggle the attribute specified
    #
    # Returns the value the attribute was changed to. Does not persist the change.
    def toggle(toggleable_attribute)
      send("#{toggleable_attribute}=", !send(toggleable_attribute))
    end

    # Public: Toggle the attribute specified and persist the change
    #
    # Returns the result of #save.
    def toggle!(toggleable_attribute)
      toggle(toggleable_attribute)
      save
    end
  end
end
