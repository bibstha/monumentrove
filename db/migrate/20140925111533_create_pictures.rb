class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name
      t.text :description
      t.references :monument, index: true
      t.date :date

      t.timestamps
    end
  end
end
