class AddPriceToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :price, :decimal, default: 0.0
  end
end
