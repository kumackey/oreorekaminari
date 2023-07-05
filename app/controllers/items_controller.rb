class ItemsController < ApplicationController
  def index
    @items = Kaminari.paginate_array((0..33).to_a).page(params[:page]).per(10)
  end
end
