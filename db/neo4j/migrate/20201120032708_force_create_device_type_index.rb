class ForceCreateDeviceTypeIndex < ActiveGraph::Migrations::Base
  def up
    add_index :Device, :type, force: true
  end

  def down
    drop_index :Device, :type
  end
end
