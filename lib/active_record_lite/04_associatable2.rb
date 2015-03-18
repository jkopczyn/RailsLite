require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    through_options = assoc_options[through_name.to_sym]
    define_method(name) do
        source_options = through_options.model_class.assoc_options[source_name]
        source_table = source_options.table_name
        through_table = through_options.table_name
        target_id = self.send(through_options.foreign_key)
        result = DBConnection.execute(<<-SQL, target_id)
          SELECT
            #{source_table}.*
          FROM
            #{through_table}
          JOIN
            #{source_table} ON
              #{source_table}.#{source_options.primary_key} = 
              #{through_table}.#{source_options.foreign_key}
          WHERE
            #{through_table}.#{through_options.primary_key} = ?
        SQL
        return source_options.model_class.parse_all(result).first
    end
  end
end
