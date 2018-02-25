class AccessTokenController < ApplicationController
  before_action :authenticate_user!

  def create
    token = AccessToken.new(token_params)
    token.user = current_user

    if token.save
      redirect_to account_index_path, notice: 'Created new Access Token'
    else
      flash.now[:error] = 'Unable to create new token.'
      render 'account/index'
    end
  end

  def destroy
    token = current_user.access_tokens.where(id: token_params[:id])

    if token.present? && token.destroy
      redirect_to account_index_path, notice: 'Revoked Access Token'
    else
      redirect_to(account_index_path, flash: {error: 'Invalid Token ID'})
    end
  end

  private

  def token_params
    params.require(:access_token).permit(:id, :title, :token_type)
  end
end
