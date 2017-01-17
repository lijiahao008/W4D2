class CatRentalRequestsController < ApplicationController
  def new
    @cat_rental_request = CatRentalRequest.new
    @cats = Cat.all

    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)

    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      flash[:notice] = @cat_rental_request.errors.full_messages

      redirect_to new_cat_rental_request_url
    end
  end

  def approve
    @cat_rental_request = CatRentalRequest.find(params[:id])

    if @cat_rental_request.approve!
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      flash[:notice] = @cat_rental_request.errors.full_messages

      redirect_to cat_url(@cat_rental_request.cat_id)
    end
  end

  def deny
    @cat_rental_request = CatRentalRequest.find(params[:id])

    if @cat_rental_request.deny!
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      flash[:notice] = @cat_rental_request.errors.full_messages

      redirect_to cat_url(@cat_rental_request.cat_id)
    end
  end

  private

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :status)
  end
end
