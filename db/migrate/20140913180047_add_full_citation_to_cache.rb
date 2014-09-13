class AddFullCitationToCache < ActiveRecord::Migration
  def change
    add_column :call_caches, :full_citation, :string
  end
end
