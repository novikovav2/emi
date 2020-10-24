class CreateInterface < ActiveGraph::Migrations::Base
  disable_transactions!

  def up
    add_constraint :Interface, :uuid
  end

  def down
    drop_constraint :Interface, :uuid
  end
end
