#---
# Excerpted from "Agile Web Development with Rails 6",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rails6 for more book information.
#---
class LineItemsController < ApplicationController
  skip_before_action :authorize, only: :create
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy, :decrement, :increment]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    session[:access_count] = 0

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_index_url }
        format.js   { @current_item = @line_item }
        format.json { render :show,
                             status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors,
                             status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
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

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      # format.html { redirect_to line_items_url, notice: 'Line item was successfully destroyed.' }
      format.html { redirect_to cart_url(@line_item.cart), notice: 'Line item was successfully removed.' }
      format.json { head :no_content }
    end
  end

  def decrement
    if @line_item.quantity > 1
      @line_item.quantity -= 1
      @line_item.save
    else
      @line_item.destroy
    end
    respond_to do |format|
      # format.html { redirect_to store_index_url }
      # format.js { redirect_to store_index_url }
      format.html { redirect_to request.referer || store_index_url }
      format.js { redirect_to request.referer || store_index_url }
    end
  end

  def increment
    @line_item.quantity += 1
    @line_item.save
    respond_to do |format|
      # format.html { redirect_to store_index_url }
      # format.js { redirect_to store_index_url }
      format.html { redirect_to request.referer || store_index_url }
      format.js { redirect_to request.referer || store_index_url }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_line_item
    @line_item = LineItem.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def line_item_params
    params.require(:line_item).permit(:product_id)
  end
  #...
end