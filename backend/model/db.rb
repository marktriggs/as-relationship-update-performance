class DB

  Sequel.extension :empty_array_ignore_nulls

  def self.supports_join_updates?
    ![:derby, :h2].include?(@pool.database_type)
  end

end
