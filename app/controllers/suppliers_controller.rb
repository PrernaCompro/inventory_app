class SuppliersController < ApplicationController
  before_action :set_supplier, only: %i[show edit update destroy]

  def index
    @suppliers = Supplier.all
    @suppliers = Supplier.active.alphabetical
    @suppliers = Supplier.active.search(params[:query]).alphabetical
    @suppliers = Supplier.active.alphabetical.with_products if params[:with_products]
    @suppliers = @suppliers.alphabetical.page(params[:page]).per(25)
  end

  def dashboard
    @recent_suppliers = Supplier.recent.limit(5)
  end

  def show
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(supplier_params)

    if @supplier.save
      redirect_to @supplier, notice: "Supplier created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @supplier.update(supplier_params)
      redirect_to @supplier, notice: "Supplier updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @supplier.soft_delete
      redirect_to suppliers_path, notice: "Supplier deactivated successfully."
    else
      redirect_to suppliers_path, alert: "Failed to deactivate supplier: #{@supplier.errors.full_messages.join(', ')}"
    end
  end

  def reactivate
    @supplier = Supplier.find(params[:id])
    @supplier.reactivate
    redirect_to suppliers_path, notice: "Supplier was reactivated."
  end

  private

  def set_supplier
    @supplier = Supplier.find(params[:id])
  end

  def supplier_params
    params.require(:supplier).permit(:name, :email, :phone, :address, :active)
  end
end
