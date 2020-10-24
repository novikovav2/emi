class CreateDevice < ActiveGraph::Migrations::Base
  disable_transactions!

  def up
    add_constraint :Device, :uuid
  end

  def down
    drop_constraint :Device, :uuid
  end
end
