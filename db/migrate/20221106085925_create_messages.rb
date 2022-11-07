class CreateMessages < ActiveRecord::Migration[7.0]
  def change
     create_table :messages do |t|
      t.references :conversation, index: true
      t.references :user, index: true
      t.references :product, index: true      
      t.boolean :read, :default => false
      t.timestamps
    end
  end
end
