module Tofu::Auth
  def auth
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
  end
  
  def unauthorized!
    Ramaze::Dispatcher::Action::FILTER << lambda { |response|
      response.header['WWW-Authenticate'] = %(Basic realm="TofuBlox")
    }
    raise Tofu::Errors::Unauthorized
  end
  
  def bad_request!
    raise Tofu::Errors::BadRequest
  end
  
  def authorized?
    request.env['REMOTE_USER']
  end
  
  def authorize(username, password)
    password == Tofu.config.admin_password
  end
  
  def require_login
    return if authorized?
    unauthorized! unless auth.provided?
    bad_request! unless auth.basic?
    unauthorized! unless authorize(*auth.credentials)
    request.env['REMOTE_USER'] = auth.username
  end  
end

