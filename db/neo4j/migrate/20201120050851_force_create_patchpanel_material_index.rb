class ForceCreatePatchpanelMaterialIndex < ActiveGraph::Migrations::Base
  def up
    add_index :Patchpanel, :material, force: true
  end

  def down
    drop_index :Patchpanel, :material
  end
end
