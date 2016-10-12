class AddProfileAreaMp < ActiveRecord::Migration
  def change
    add_column  :users, :profile, :string
    add_column  :users, :area, :string
  end
end
