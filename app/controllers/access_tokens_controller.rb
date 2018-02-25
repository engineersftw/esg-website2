class AccessTokensController < ApplicationController
  before_action :authenticate_user!

  def new
    token_type = token_type_enum_for(params[:token_type])

    @access_token = AccessToken.new(token_type: token_type, active: true)
  end

  def create
    @access_token = AccessToken.new(
                           title: token_params[:title],
                           token_type: token_type_enum_for(token_params[:token_type]),
                           access_token: AccessToken.generate_token_string,
                           active: true,
                           user: current_user
    )

    if @access_token.save
      redirect_to account_index_path, notice: 'Created new Access Token'
    else
      flash.now[:alert] = 'Unable to create new token: ' + @access_token.errors.full_messages.join(". ")
      render :new
    end
  end

  def destroy
    token = current_user.access_tokens.where(id: params[:id])&.first

    if token.present? && token.destroy
      redirect_to account_index_path, notice: 'Revoked Access Token'
    else
      redirect_to(account_index_path, flash: {error: 'Invalid Token ID'})
    end
  end

  private

  def token_type_enum_for(token_type_string)
    case token_type_string
       when 'stream_key'
         AccessToken::token_types[:stream_key]
       when 'api_key'
         AccessToken::token_types[:api_key]
       else
         AccessToken::token_types[:stream_key]
     end
  end

  def token_params
    params.require(:access_token).permit(:title, :token_type)
  end
end
