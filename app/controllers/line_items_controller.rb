class LineItemsController < ApplicationController
  include CurrentCart
  skip_before_action :authorize, only: :create
  before_action :set_cart, only: [:create, :change]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy, :change]

  rescue_from ActiveRecord::RecordNotFound, with: :invalid_item
  rescue_from NoMethodError, with: :invalid_method

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/:id
  # GET /line_items/:id.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/:id/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    session[:store_index_visit_counter] = 1 unless session[:store_index_visit_counter].nil?
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_index_url, notice: 'Line item was successfully created.' }
        format.js { @current_item = @line_item }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/:id
  # PATCH/PUT /line_items/:id.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/:id
  # DELETE /line_items/:id.json
  def destroy
    @line_item.destroy if @line_item.cart_id == session[:cart_id]
    redirect_path = @line_item.cart.line_items.count > 0 ? @line_item.cart : store_index_url
    respond_to do |format|
      format.html { redirect_to redirect_path, notice: "Product '#{@line_item.product.title}' was removed." }
      format.js { @cart = @line_item.cart }
      format.json { head :no_content }
    end
  end

  # PATCH /line_items/:id/change
  def change
    case params[:type]
    when 'inc'
      @line_item.increment(:quantity)
    when 'dec'
      return destroy if @line_item.quantity < 2
      @line_item.decrement(:quantity)
    else
      raise "Invalid operation on line_item #{params[:type]}"
    end

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_index_url, notice: 'Line item quantity was successfully updated.' }
        format.js { @current_item = @line_item }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end

    def invalid_item
      logger.error "Attempt to access invalid item #{params[:id]}"
      redirect_to store_index_url, notice: 'Invalid item'
    end

    def invalid_method
      logger.error "Attempt to access invalid method"
      redirect_to store_index_url, notice: 'Invalid method'
    end
end
