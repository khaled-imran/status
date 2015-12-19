class CreatePageUpdates < ActiveRecord::Migration
  def change
    create_table :page_updates do |t|

      t.text :content

      t.timestamps null: false
    end
  end
end
