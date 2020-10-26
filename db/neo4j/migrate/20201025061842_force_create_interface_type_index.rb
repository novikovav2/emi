class ForceCreateInterfaceTypeIndex < ActiveGraph::Migrations::Base
  def up
    add_index :Interface, :type, force: true
  end

  def down
    drop_index :Interface, :type
  end
end
