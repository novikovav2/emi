class ForceCreateInterfaceMaterialIndex < ActiveGraph::Migrations::Base
  def up
    add_index :Interface, :material, force: true
  end

  def down
    drop_index :Interface, :material
  end
end
