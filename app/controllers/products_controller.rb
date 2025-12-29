class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.includes(:supplier)
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
    @product.destroy
    redirect_to products_path, notice: "Product deleted successfully."
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
