class AddOriginalToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :original, :integer
  end
end
