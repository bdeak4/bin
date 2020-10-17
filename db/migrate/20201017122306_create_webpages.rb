class CreateWebpages < ActiveRecord::Migration[6.0]
  def change
    create_table :webpages do |t|
      t.string :url
      t.string :element
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
