class CreateCurrency < ActiveRecord::Migration
  def  self.up
    create_table :currencies do |t|
      t.string :iso_code, required: true
      t.string :name, required: true
      t.string :format, required: true, default: '%{amount} %{iso_code}'
      t.integer :decimal_digits, required: true, default: 2

      t.timestamps
    end
  end
  def self.down
    drop_table :currencies
  end
end
