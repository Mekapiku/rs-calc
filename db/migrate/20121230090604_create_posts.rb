# -*- coding: utf-8 -*-
class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :room, :null => false
      t.integer :users, :null => false, :inclusion => { :in => 0..300 }
      t.integer :unavailable, :null => false, :default => 0, :inclusion => { :in => 0..300 }
      t.boolean :calc_base
      t.integer :windows
      t.integer :linux

      # 以下は上の項目から自動的に算出される
      t.float :rate, :null => false, :default => 10.0
      t.integer :available, :null => false, :default => 10

      t.timestamps
    end
  end
end
