class ForceCreatePatchpanelUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :Patchpanel, :uuid, force: true
  end

  def down
    drop_constraint :Patchpanel, :uuid
  end
end
