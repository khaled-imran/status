class AddUserIdToPageUpdates < ActiveRecord::Migration
  def change
    add_column :page_updates, :user_id, :integer
  end
end
