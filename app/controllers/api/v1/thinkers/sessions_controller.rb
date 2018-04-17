class Api::V1::Thinkers::SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [:create]

  skip_before_action :verify_authenticity_token

  before_action :validate_auth_token, :except => :create

  include Devise::Controllers::Helpers
  include Api::V1::BaseHelper

  respond_to :json

  def create
    resource = Thinker.find_for_database_authentication(:email => params[:thinker][:email])
    return failure unless resource

    if resource.valid_password?(params[:thinker][:password])
      sign_in(:thinker, resource)
      render :json=> { :success => true, :token => resource.authentication_token }
      return
    end

    failure
  end

  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

    render :status => 200, :json => {}
  end

  private

  def failure
    render json: { success: false, errors: [t('api.v1.sessions.invalid_login')] }, :status => :unauthorized
  end
end
