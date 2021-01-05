class ImportsController < ApplicationController
  before_action :set_page_title

  # GET /imports/devices
  def devices
    @page_title << 'Оборудование'
  end

  # POST /imports/devices
  def load_devices
    require 'csv'
    @page_title << 'Результат импорта'

    @data = []
    i = 1
    CSV.foreach(params[:csv], headers: true ) do |row|
      data_row = {num: i, name: row['name'], box: row['box']}
      status = ''
      success = false

      box = Box.where(name: row['box']).first
      if box
        status += 'Box found. '
        device = Device.new(name: row['name'], box: box.id)
        if device.save
          status += 'Device created. '
          success = true
        else
          status += 'Device not created. '
        end
      else
        status += 'Box not found. '
      end

      data_row[:status] = status
      data_row[:success] = success
      @data << data_row
      i += 1
    end
  end

  # GET /imports/patchpanels
  def patchpanels
    @page_title << 'Патчпанели'
  end

  # POST /imports/patchpanels
  def load_patchpanels
    require 'csv'
    @page_title << 'Результат импорта'

    @data = []
    i = 1
    CSV.foreach(params[:csv], headers: true ) do |row|
      data_row = {num: i, name: row['name'], box: row['box']}
      status = ''
      success = false

      box = Box.where(name: row['box']).first
      if box
        status += 'Box found. '
        device = Patchpanel.new(name: row['name'], box: box.id)
        if device.save
          status += 'Patchpanel created. '
          success = true
        else
          status += 'Patchpanel not created. '
        end
      else
        status += 'Box not found. '
      end

      data_row[:status] = status
      data_row[:success] = success
      @data << data_row
      i += 1
    end
  end

  # GET /imports/logical_links
  def logical_links
    @page_title << 'Логические связи'
  end

  # POST /imports/logical_links
  def load_logical_links
    require 'csv'
    @page_title << 'Результат импорта'

    @data = []
    i = 1
    CSV.foreach(params[:csv], headers: true ) do |row|
      data_row = {num: i, from_device: row['from_device'], from_interface: row['from_interface'],
                  to_device: row['to_device'], to_interface: row['to_interface']}
      status = ''
      success = false

      from_device = Device.where(name: row['from_device']).first
      if from_device
        status += 'From_device found. '
        from_interface = from_device.interfaces.where(name: row['from_interface']).first
        if from_interface
          status += 'From_interface found. '
        else
          status += 'From_interface not found. '
        end
      else
        status += 'From_device not found. '
      end

      to_device = Device.where(name: row['to_device']).first
      if to_device
        status += 'To_device found. '
        to_interface = to_device.interfaces.where(name: row['to_interface']).first
        if to_interface
          status += 'To_interface found. '
        else
          status += 'To_interface not found. '
        end
      else
        status += 'To_device not found. '
      end

      if from_interface and to_interface
        logical_link = LogicalLink.new(from_node: from_interface,
                                       to_node: to_interface)
        if logical_link.save
          status += 'Logical link created. '
          success = true
        else
          status += 'Logical link not created. '
        end
      end

      data_row[:status] = status
      data_row[:success] = success
      @data << data_row
      i += 1
    end
  end

  # GET /imports/cables
  def cables
    @page_title << 'СКС'
  end

  # POST /imports/cables
  def load_cables
    require 'csv'
    @page_title << 'Результат импорта'

    @data = []
    i = 1
    CSV.foreach(params[:csv], headers: true ) do |row|
      data_row = {num: i,
                  from_box: row['from_box'],
                  from_patchpanel: row['from_patchpanel'],
                  from_interface: row['from_interface'],
                  to_box: row['to_box'],
                  to_patchpanel: row['to_patchpanel'],
                  to_interface: row['to_interface']}
      status = ''
      success = false

      from_box = Box.where(name: row['from_box']).first
      if from_box
        status += 'From_box found. '
        from_patchpanel = from_box.patchpanels.where(name: row['from_patchpanel']).first
        if from_patchpanel
          status += 'From_patchpanel found. '
          from_interface = from_patchpanel.interfaces.where(name: row['from_interface']).first
          if from_interface
            status += 'From_interface found. '
          else
            status += 'From_interface not found. '
          end
        else
          status += 'From_patchpanel not found. '
        end
      else
        status += 'From_box not found. '
      end

      to_box = Box.where(name: row['to_box']).first
      if to_box
        status += 'To_box found. '
        to_patchpanel = to_box.patchpanels.where(name: row['to_patchpanel']).first
        if to_patchpanel
          status += 'To_patchpanel found. '
          to_interface = to_patchpanel.interfaces.where(name: row['to_interface']).first
          if to_interface
            status += 'To_interface found. '
          else
            status += 'To_interface not found. '
          end
        else
          status += 'To_patchpanel not found. '
        end
      else
        status += 'To_box not found. '
      end

      if from_interface and to_interface
        cable = Cable.new(from_node: from_interface,
                          to_node: to_interface)
        if cable.save
          status += 'Cable created. '
          success = true
        else
          status += 'Cable not created. '
        end
      end

      data_row[:status] = status
      data_row[:success] = success
      @data << data_row
      i += 1
    end
  end


  # GET /imports/patchcords
  def patchcords
    @page_title << 'Патчкорды'
  end

  # POST /imports/patchcords
  def load_patchcords
    require 'csv'
    @page_title << 'Результат импорта'

    @data = []
    i = 1
    CSV.foreach(params[:csv], headers: true ) do |row|
      data_row = {num: i,
                  from_box: row['from_box'],
                  from_owner: row['from_owner'],
                  from_interface: row['from_interface'],
                  to_box: row['to_box'],
                  to_owner: row['to_owner'],
                  to_interface: row['to_interface']}
      status = ''
      success = false

      from_box = Box.where(name: row['from_box']).first
      if from_box
        status += 'From_box found. '

        from_owner = from_box.devices.where(name: row['from_owner']).first
        if from_owner.nil?
          from_owner = from_box.patchpanels.where(name: row['from_owner']).first
        end

        if from_owner
          status += 'From_owner found. '
          from_interface = from_owner.interfaces.where(name: row['from_interface']).first
          if from_interface
            status += 'From_interface found. '
          else
            status += 'From_interface not found. '
          end
        else
          status += 'From_owner not found. '
        end
      else
        status += 'From_box not found. '
      end

      to_box = Box.where(name: row['to_box']).first
      if to_box
        status += 'To_box found. '

        to_owner = to_box.devices.where(name: row['to_owner']).first
        if to_owner.nil?
          to_owner = to_box.patchpanels.where(name: row['to_owner']).first
        end

        if to_owner
          status += 'To_owner found. '
          to_interface = to_owner.interfaces.where(name: row['to_interface']).first
          if to_interface
            status += 'To_interface found. '
          else
            status += 'To_interface not found. '
          end
        else
          status += 'To_owner not found. '
        end
      else
        status += 'To_box not found. '
      end

      if from_interface and to_interface
        patchcord = Patchcord.new(from_node: from_interface,
                          to_node: to_interface)
        if patchcord.save
          status += 'Patchcord created. '
          success = true
        else
          status += 'Patchcord not created. '
        end
      end

      data_row[:status] = status
      data_row[:success] = success
      @data << data_row
      i += 1
    end
  end

  private
  def set_page_title
    @page_title = ['Импорт']
  end
end