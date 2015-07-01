class DB

  Sequel.empty_array_handle_nulls = false

  def self.supports_join_updates?
    ![:derby, :h2].include?(@pool.database_type)
  end

end
