require 'active_support/core_ext/array/extract_options'
require 'mongoid'
require 'mongoid_toggleable/version'
require 'mongoid/toggleable'

module MongoidToggleable
  def self.mongoid3?
    ::Mongoid.const_defined? :Observer # deprecated in Mongoid 4.x
  end

  def self.boolean_type
    mongoid3? ? Boolean : Mongoid::Boolean
  end
end
