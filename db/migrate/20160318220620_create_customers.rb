class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :company, :string
      t.column :address, :text
      t.column :phone, :string
      t.column :email, :string
      t.column :website, :string
    end
  end

  def self.down
    drop_table :customers
  end
end
