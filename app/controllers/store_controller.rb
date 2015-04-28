class StoreController < ApplicationController
    helper_method :sort_column, :sort_direction

  def index
    if params[:set_locale]
      redirect_to sotre_path(:locale => params[:set_locale])
    else
  	@cart = current_cart
    @store =  Product.all.paginate(:per_page => 10, :page => params[:page])
    end    

  end

  private

  	def sort_column
     Product.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
