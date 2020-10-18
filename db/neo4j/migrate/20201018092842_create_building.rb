class CreateBuilding < ActiveGraph::Migrations::Base
  disable_transactions!

  def up
    add_constraint :Building, :uuid
  end

  def down
    drop_constraint :Building, :uuid
  end
end
