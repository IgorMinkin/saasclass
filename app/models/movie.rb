class Movie < ActiveRecord::Base
  def self.ratings
    @@movie_ratings = ['G','PG','PG-13','R','NC-17']
  end
  
  def self.valid_column?(column_name)
    self.column_names.any? { |col| col == column_name.to_s }
  end
end