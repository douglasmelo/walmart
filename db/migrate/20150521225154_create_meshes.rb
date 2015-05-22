class CreateMeshes < ActiveRecord::Migration
  def change
    create_table :meshes do |t|
      t.string :origin
      t.string :destination
      t.string :map_name
      t.float :distance

      t.timestamps
    end
  end
end
