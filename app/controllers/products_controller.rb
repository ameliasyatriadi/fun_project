class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def validate_upc_code
    upc_code = params[:upc_code]
    product = Product.find_by(upc_code: upc_code)

    render json: { exists: !product.nil? }
  end

  def fetch_product_info
    upc_code = params[:upc_code]
    
    begin
      response = URI.open("http://world.openfoodfacts.org/api/v0/product/#{upc_code}.json")
      data = JSON.parse(response.read)

      product_name = data['product']['product_name']
      brands = data['product']['brands']
      quantity = data['product']['quantity']
      image_url = data['product']['image_url']

      @product = Product.create!(
        upc_code: upc_code,
        product_name: product_name,
        brand: brands,
        quantity: quantity,
        image_url: image_url
      )

      render json: { message: "Product information saved to the database", product: @product }
    rescue OpenURI::HTTPError => e
      render json: { error: "Error fetching product information: #{e}" }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:upc_code, :product_name, :brand, :quantity, :image_url)
    end
end
