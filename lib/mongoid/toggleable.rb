module Mongoid
  module Toggleable
    extend ActiveSupport::Concern

    included do
      extend ClassMethods
    end

    module ClassMethods
      def toggleable(*toggleable_attributes)
        defaults = { :default => true, :index => true }
        options = toggleable_attributes.extract_options!.dup
        options = defaults.merge(options)

        toggleable_attributes.each do |toggleable_attribute|
          field toggleable_attribute, :type => MongoidToggleable.boolean_type, :default => options[:default]
          index({ toggleable_attribute => 1 }, { :name => "#{toggleable_attribute}_index" }) if options[:index]
        end
      end

      def find_toggleable(toggleable_attribute, state)
        where(toggleable_attribute => state)
      end
    end

    def toggle(toggleable_attribute)
      send("#{toggleable_attribute}=", !send(toggleable_attribute))
    end

    def toggle!(toggleable_attribute)
      toggle(toggleable_attribute)
      save
    end
  end
end
