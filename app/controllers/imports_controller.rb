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

  private
  def set_page_title
    @page_title = ['Импорт']
  end
end