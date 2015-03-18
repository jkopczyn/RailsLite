require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'

# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    cols = DBConnection.execute2(<<-SQL) 
    SELECT
      * 
    FROM
      #{self.table_name}
    WHERE
      NULL
    SQL
    cols.first.map(&:to_sym)
  end

  def self.finalize!
    define_method(:attributes) do
      @attributes ||= {}
    end
    columns.each do |column|
      define_method("#{column}".to_sym) do 
        attributes[column.to_sym]
      end
      define_method("#{column}=".to_sym) do |val|
        attributes[column.to_sym]=val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    if @table_name.nil?
       @table_name = self.to_s.tableize
    end
    @table_name 
  end

  def self.all
    self.parse_all(DBConnection.execute(<<-SQL))
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
  end

  def self.parse_all(results)
    results.map do |hash|
      self.new(hash)
    end
  end

  def self.find(id)
    thing = DBConnection.execute(<<-SQL, {id: id})
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        id = :id
      LIMIT
        1
    SQL
    if thing.nil? || thing.empty?
      nil
    else
      accum = Hash.new
      thing.first.map do |k,v|
        accum[k.to_sym]=v
      end

      self.new(accum)
    end
  end

  def initialize(params = {})
    # ...
    params.keys.each do |key|
      sym_key = key.to_sym
      unless self.class.columns.include?(sym_key) 
        raise "unknown attribute '#{key}'"
      end
      self.send("#{key}=".to_sym, params[key])
    end
  end

  def attributes
    @attributes ||= {}
  end

  def columns
    self.class.columns
  end

  def attribute_values
    self.columns.map {|col| attributes[col] }
  end

  def col_names
    self.columns.join(",")
  end

  def insert
    DBConnection.execute(<<-SQL,*attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{"?,"*(self.columns.length-1)}?)
    SQL
    attributes[:id] = DBConnection.last_insert_row_id
  end

  def update
    col_string = columns.map { |col| " #{col} = ?" }.join(", ")
    DBConnection.execute(<<-SQL,*attribute_values)
      UPDATE
        #{self.class.table_name}
      SET
        #{col_string}
      WHERE
        id = #{self.id}
    SQL
    attributes[:id] = DBConnection.last_insert_row_id
  end

  def save
    if self.id.nil?
      self.insert
    else
      self.update
    end
  end
end
