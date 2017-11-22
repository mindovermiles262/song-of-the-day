class CreateSotd < ActiveRecord::Migration[5.1]
  def change
    create_table :sotd do |t|
      t.string :title
      t.string :artist
      t.date :sotd_date
      t.timestamps null: false
    end
  end
end