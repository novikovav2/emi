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

  def logical_links
    @page_title << 'Логические связи'
  end

  # POST /imports/patchpanels
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

  private
  def set_page_title
    @page_title = ['Импорт']
  end
end