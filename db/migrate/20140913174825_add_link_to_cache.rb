class AddLinkToCache < ActiveRecord::Migration
  def change
    add_column :call_caches, :url, :string
  end
end
