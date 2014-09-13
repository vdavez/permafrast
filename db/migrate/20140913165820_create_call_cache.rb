class CreateCallCache < ActiveRecord::Migration
  def change
    create_table :call_caches do |t|
     t.string :volume
     t.string :reporter
     t.string :page
     t.text :fetched_page
     t.timestamps
   end
  end
end
