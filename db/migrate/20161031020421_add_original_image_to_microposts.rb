class AddOriginalImageToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :original_image, :string
  end
end
