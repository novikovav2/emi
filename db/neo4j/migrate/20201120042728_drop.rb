class Drop < ActiveGraph::Migrations::Base
  def up
    drop_index :Device, :type
  end

  def down
    raise ActiveGraph::IrreversibleMigration
  end
end
