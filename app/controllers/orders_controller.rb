class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_cart


  # GET /orders
  # GET /orders.json
  def index
    @orders = current_user.orders.paginate(page: params[:page], per_page: 20)
    
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @cart = current_cart
    if @cart.line_items.empty?
      redirect_to store_url, notice: "Your cart is empty"
      return
    end 
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = current_user.orders.build(order_params)
    @order.add_line_items_from_cart(current_cart)

      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        Notifier.order_received(@order).deliver_now
        redirect_to store_path , notice: 'Thank for your order.'
        I18n.t('.thanks')
      else
        render 'new'
      end
    
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type)
    end

    def set_cart
      @cart = current_cart
    end
end
