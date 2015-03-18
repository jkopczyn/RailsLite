require_relative '02_searchable'
require 'active_support/inflector'

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'human', 'humans'
end

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    class_name.pluralize.underscore
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = (options[:foreign_key] || 
                    "#{name.to_s.underscore}_id").to_sym
    @primary_key = (options[:primary_key] || :id).to_sym
    @class_name  = (options[:class_name] || 
                    "#{name.to_s.singularize.camelcase}").to_s
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = (options[:foreign_key] ||
                    "#{self_class_name.to_s.underscore}_id").to_sym
    @primary_key = (options[:primary_key] || :id).to_sym
    @class_name  = (options[:class_name] ||
                    "#{name.to_s.singularize.camelcase}").to_s
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    assoc_options[name.to_sym] = BelongsToOptions.new(name, options)
    options = assoc_options[name.to_sym]
    define_method(name.to_sym) do 
      target_id = self.send(options.foreign_key)

      options.model_class.where({options.primary_key => target_id}).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    define_method(name.to_sym) do 
      target_id = self.send(options.primary_key)

      options.model_class.where({options.foreign_key => target_id})
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
