class Api::V1::BaseController < ActionController::Metal
  include ActionController::Rendering        # enables rendering
  include ActionController::MimeResponds     # enables serving different content types like :xml or :json
  include AbstractController::Callbacks      # callbacks for your authentication logic
  include ActionController::RequestForgeryProtection
  include ActionView::Layouts
  
  append_view_path "#{Rails.root}/app/views" # you have to specify your views location as well

  acts_as_token_authentication_handler_for Thinker

  protect_from_forgery with: :null_session
end
