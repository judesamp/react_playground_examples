class AddDateColumnToMeetups < ActiveRecord::Migration
  def change
    add_column :meetups, :date, :date
    execute "UPDATE meetups SET date = '#{Date.current.to_s(:db)}' "
    change_column :meetups, :date, :date, null: false
  end
end
