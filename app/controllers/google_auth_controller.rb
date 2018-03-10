class GoogleAuthController < ApplicationController
  before_action :authenticate_user!

  API_SCOPE = [
      'email',
      'profile',
      'https://www.googleapis.com/auth/plus.me',
      'https://www.googleapis.com/auth/youtube.force-ssl',
      'https://www.googleapis.com/auth/youtube',
      'https://www.googleapis.com/auth/youtubepartner',
      'https://www.googleapis.com/auth/youtube.upload',
  ]

  def start
    session[:return_url] = params[:return_url]

    redirect_to auth_service.get_authorization_uri(redirect_uri: callback_url, scope: API_SCOPE)
  end

  def callback
    tokens = auth_service.fetch_tokens(redirect_uri: callback_url, scope: API_SCOPE, code: params[:code])

    if tokens
      session[:access_token] = tokens[:access_token]
      session[:refresh_token] = tokens[:refresh_token]

      identity = identity_from_gplus(tokens)
      if identity
        identity.user = current_user
        identity.save!
      end
    end

    if session[:return_url].present?
      return redirect_to(session[:return_url], notice: 'YouTube Channel has been successfully added to your account.')
    end

    render json: {access_token: tokens[:access_token], refresh_token: tokens[:refresh_token]}
  end

  private

  def identity_from_gplus(tokens)
    conn = Faraday.new(url: 'https://www.googleapis.com')
    api_response = conn.get do |req|
      req.url '/plus/v1/people/me'
      req.headers['Authorization'] = "Bearer #{tokens[:access_token]}"
    end
    gplus_user = JSON.parse api_response.body, symbolize_names: true

    identity = Identity.find_or_create_by(uid: gplus_user[:id], provider: 'google_plus')

    identity.email = gplus_user[:emails].first[:value] if gplus_user[:emails].count > 0
    identity.avatar_url = gplus_user[:image][:url] if gplus_user[:image]
    identity.access_token = tokens[:access_token]
    identity.refresh_token = tokens[:refresh_token] if tokens[:refresh_token]
    identity.save

    identity
  end

  def callback_url
    url_for(action: :callback)
  end

  def auth_service
    @service ||= GoogleAuthService.new
  end
end
