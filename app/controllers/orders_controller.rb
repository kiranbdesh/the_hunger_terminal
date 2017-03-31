class OrdersController < ApplicationController

  load_and_authorize_resource  param_method: :order_params
 
  def index
    @orders = current_user.orders
  end

  def load_terminal
    @terminals = Terminal.where(active: true, company: current_user.company)
  end

  def new
    @order = Order.new  
    @terminal_id = params[:terminal_id]
    @menu_items = MenuItem.where(terminal_id: params[:terminal_id])
    
  end
  def edit
    @order = Order.find(params[:id])
    @terminal_id = params[:terminal_id]
    @menu_items = MenuItem.where(terminal_id: params[:terminal_id])
  end

  def update
    @order = Order.find(params[:id])
    @order.order_details = OrderDetail.where(params[:order_id])
    @order.order_details.clear
    if @order.update_attributes(order_params)
      redirect_to @order
    else
      render 'edit'
    end
  end

  def create
    @order = Order.new(order_params)
    load_order_detail
    if @order.save
      redirect_to @order
    else
      flash[:error] = @order.errors.messages
      redirect_to vendors_path
    end
  end
  
  def show
    @order = current_user.orders.find(params[:id])
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to vendors_path

  end
  private

  def order_params
    params.require(:order).permit(
      :total_cost,:terminal_id, order_details_attributes:[:menu_item_id, :quantity]
    ).merge(user_id: current_user.id)
  end

  def load_order_detail
    @order.date = Date.today
    @order.company_id = current_user.company.id
  end

end
