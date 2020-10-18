class CreateBox < ActiveGraph::Migrations::Base
  disable_transactions!

  def up
    add_constraint :Box, :uuid
  end

  def down
    drop_constraint :Box, :uuid
  end
end
