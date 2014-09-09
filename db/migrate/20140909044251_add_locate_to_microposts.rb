class AddLocateToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :locate, :string
  end
end
