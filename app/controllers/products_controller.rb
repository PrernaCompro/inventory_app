class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.includes(:supplier)
    apply_filters
    apply_sorting
    @products = @products.page(params[:page]).per(25)
  end

    private

    def apply_filters
      @products = Product.active.alphabetical
      @products = @products.in_stock if params[:in_stock]
      @products = @products.low_stock if params[:low_stock]
      @products = @products.cheap if params[:cheap]
      @products = @products.search(params[:query]) if params[:query].present?
      @products = @products.by_supplier(params[:supplier_id]) if params[:supplier_id].present?
      @products = @products.price_between(params[:min_price], params[:max_price]) if params[:min_price] && params[:max_price]
    end

    def apply_sorting
      @products = case params[:sort]
        when "price_asc"
          @products.by_price_asc
        when "price_desc"
          @products.by_price_desc
        when "quantity_asc"
          @products.by_quantity_asc
        when "quantity_desc"
          @products.by_quantity_desc
        when "recent"
          @products.recent
        when "name"
          @products.alphabetical
        else
          @products.alphabetical  # Default sort
        end
    end
  end

  def out_of_stock
    @products = Product.active.out_of_stock.alphabetical
  end

  def show
  end

  def new
    @product = Product.new
    load_suppliers
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: "Product created successfully."
    else
      load_suppliers
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_suppliers
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product updated successfully."
    else
      load_suppliers
      render :edit, status: :unprocessable_entity
    end
  end

def destroy
  if @product.destroy
    redirect_to products_path, notice: "Product deleted successfully."
  else
    redirect_to products_path, alert: "Failed to delete product: #{@product.errors.full_messages.join(', ')}"
  end
end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def load_suppliers
    @suppliers = Supplier.all
  end

  def product_params
    params.require(:product).permit(
      :name,
      :sku,
      :price,
      :quantity,
      :active,
      :supplier_id
    )
  end
end
