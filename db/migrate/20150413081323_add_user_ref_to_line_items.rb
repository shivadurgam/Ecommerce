class AddUserRefToLineItems < ActiveRecord::Migration
  def change
    add_reference :line_items, :user, index: true
    add_foreign_key :line_items, :users
  end
end
