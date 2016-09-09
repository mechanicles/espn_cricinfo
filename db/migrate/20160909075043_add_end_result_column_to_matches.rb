class AddEndResultColumnToMatches < ActiveRecord::Migration[5.0]
  def change
    add_column :matches, :end_result, :string
  end
end
