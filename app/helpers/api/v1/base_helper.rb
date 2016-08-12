module Api::V1::BaseHelper
  def validate_auth_token
    self.resource = User.find_by_authentication_token(params[:authentication_token])
    render :status => 401, :json => {errors: [t('api.v1.token.invalid_token')]} if self.resource.nil?
  end
end
