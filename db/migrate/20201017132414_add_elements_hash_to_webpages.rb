class AddElementsHashToWebpages < ActiveRecord::Migration[6.0]
  def change
    add_column :webpages, :elements_hash, :string
  end
end
