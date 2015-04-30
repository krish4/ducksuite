class WidgetController < ApplicationController
  layout "angular"
  before_filter :set_widget_type
  before_filter :set_album_id

  def index
    if is_published
      render "widget.js"
    else
      head :ok, content_type: "application/javascript"
    end
  end

  # GET widget/preview/:widget_type/:album_id
  def preview
  end

  private

  def is_published
    @is_published ||= Album.find(@album_id).is_published
  end

  def set_widget_type
    @widget_type ||= params[:widget_type]
  end

  def set_album_id
    @album_id ||= params[:album_id]
  end 
end