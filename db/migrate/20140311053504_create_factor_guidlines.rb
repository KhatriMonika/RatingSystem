class CreateFactorGuidlines < ActiveRecord::Migration
  def change
    create_table :factor_guidlines do |t|
      t.string :description
      t.integer :value
      t.string :factor_id

      t.timestamps
    end
  end
end
