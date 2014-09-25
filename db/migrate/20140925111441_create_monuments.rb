class CreateMonuments < ActiveRecord::Migration
  def change
    create_table :monuments do |t|
      t.string :name
      t.text :description
      t.references :collection, index: true
      t.references :user, index: true
      t.references :category, index: true

      t.timestamps
    end
  end
end
