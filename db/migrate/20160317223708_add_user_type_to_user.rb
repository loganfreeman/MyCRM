class AddUserTypeToUser < ActiveRecord::Migration
  def change
    unless column_exists? :users, :user_type
      add_column :users, :user_type, :string
    end
  end
end
