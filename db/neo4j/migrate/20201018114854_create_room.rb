class CreateRoom < ActiveGraph::Migrations::Base
  disable_transactions!

  def up
    add_constraint :Room, :uuid
  end

  def down
    drop_constraint :Room, :uuid
  end
end
